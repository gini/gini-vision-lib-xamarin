//
//  GVLProxy.swift
//  GVLProxy
//
//  Created by Maciej Trybilo on 16.04.20.
//  Copyright © 2020 Gini GmbH. All rights reserved.
//

import Foundation
import GiniVision
import Gini
import TrustKit

@objc(GiniSDKProxy)
public class GiniSDKProxy: NSObject {
    
    private let giniSDK: GiniSDK
    
    @objc public init(id: String, secret: String, domain: String) {
        
        let builder = GiniSDK.Builder(client: Client(id: id, secret: secret, domain: domain))
        
        giniSDK = builder.build()
        
        super.init()
    }
        
    @objc public func removeStoredCredentials() {
        try? giniSDK.removeStoredCredentials()
    }
}

@objc(AnalysisResultProxy)
public class AnalysisResultProxy: NSObject {
    
    @objc public let images: [UIImage]
    
    @objc public let extractions: [ExtractionProxy]
    
    @objc public init(extractions: [ExtractionProxy], images: [UIImage]) {
        self.extractions = extractions
        self.images = images
        
        super.init()
    }
    
    convenience init(analysisResult: AnalysisResult) {
        
        let extractionProxies = analysisResult.extractions.map { ExtractionProxy(extraction: $0.value) }
        self.init(extractions: extractionProxies, images: analysisResult.images)
    }
}

@objc(GVLProxyDelegate)
public protocol GVLProxyDelegate {
    
    @objc func giniVisionAnalysisDidFinishWith(result: AnalysisResultProxy)//,
    //sendFeedbackBlock: @escaping ([String : ExtractionProxy]) -> Void)
    
    @objc func giniVisionAnalysisDidFinishWithoutResults(_ showingNoResultsScreen: Bool)
    
    @objc func giniVisionDidCancelAnalysis()
}

@objc(GVLProxy)
public class GVLProxy : NSObject {
    
    private var client: Client
    private let resultsDelegate: ResultsDelegate
    
    @objc public let viewController: UIViewController
    
    @objc
    public init(domain: String,
                id: String,
                secret: String,
                delegate: GVLProxyDelegate) {
        
        self.client = Client(id: id, secret: secret, domain: domain)
        self.resultsDelegate = ResultsDelegate()
        self.resultsDelegate.gvlProxyDelegate = delegate
        
        self.viewController = GiniVision.viewController(withClient: Client(id: id, secret: secret, domain: domain),
                                                        configuration: GiniConfiguration(),
                                                        resultsDelegate: resultsDelegate)
        
        super.init()
    }
}

private class ResultsDelegate: GiniVisionResultsDelegate {
    
    weak var gvlProxyDelegate: GVLProxyDelegate?
    
    public func giniVisionAnalysisDidFinishWith(result: AnalysisResult,
                                                sendFeedbackBlock: @escaping ([String : Extraction]) -> Void) {
        
        gvlProxyDelegate?.giniVisionAnalysisDidFinishWith(result: AnalysisResultProxy(analysisResult: result))
    }
    
    public func giniVisionAnalysisDidFinishWithoutResults(_ showingNoResultsScreen: Bool) {
        
        gvlProxyDelegate?.giniVisionAnalysisDidFinishWithoutResults(showingNoResultsScreen)
    }
    
    public func giniVisionDidCancelAnalysis() {
        
        gvlProxyDelegate?.giniVisionDidCancelAnalysis()
    }
}
