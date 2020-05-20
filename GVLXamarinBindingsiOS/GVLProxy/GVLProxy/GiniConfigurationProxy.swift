//
//  GiniConfigurationProxy.swift
//  GVLProxy
//
//  Created by Maciej Trybilo on 11.05.20.
//  Copyright © 2020 Gini GmbH. All rights reserved.
//

import Foundation
import GiniVision

@objc(GiniConfigurationProxy)
public class GiniConfigurationProxy: NSObject {
    
    @objc public var debugModeOn = false
    @objc public var fileImportSupportedTypes: GiniConfigurationProxy.GiniVisionImportFileTypesProxy = .none
    @objc public var flashToggleEnabled = false
    @objc public var openWithEnabled = false
    @objc public var qrCodeScanningEnabled = false
    @objc public var multipageEnabled = false
    @objc public var navigationBarItemTintColor: UIColor?
    @objc public var navigationBarTintColor: UIColor?
    @objc public var navigationBarTitleColor: UIColor?
    @objc public var navigationBarItemFont: UIFont?
    @objc public var navigationBarTitleFont: UIFont?
    
}

extension GiniConfigurationProxy {
    
    @objc(GiniVisionImportFileTypesProxy)
    public enum GiniVisionImportFileTypesProxy: Int {
        case none
        case pdf
        case pdf_and_images
    }
}

extension GiniConfiguration.GiniVisionImportFileTypes {
    
    init(giniVisionImportFileTypesProxy: GiniConfigurationProxy.GiniVisionImportFileTypesProxy) {
        
        switch giniVisionImportFileTypesProxy {
        case .none: self = .none
        case .pdf: self = .pdf
        case .pdf_and_images: self = .pdf_and_images
        }
    }
}

extension GiniConfiguration {
    
    convenience init(giniConfigurationProxy: GiniConfigurationProxy) {
        
        self.init()
        
        self.debugModeOn = giniConfigurationProxy.debugModeOn
        
        self.fileImportSupportedTypes = GiniConfiguration.GiniVisionImportFileTypes(giniVisionImportFileTypesProxy: giniConfigurationProxy.fileImportSupportedTypes)
        self.flashToggleEnabled = giniConfigurationProxy.flashToggleEnabled
        self.openWithEnabled = giniConfigurationProxy.openWithEnabled
        self.qrCodeScanningEnabled = giniConfigurationProxy.qrCodeScanningEnabled
        self.multipageEnabled = giniConfigurationProxy.multipageEnabled
        
        if let navigationBarItemTintColor = giniConfigurationProxy.navigationBarItemTintColor {
            self.navigationBarItemTintColor = navigationBarItemTintColor
        }
        
        if let navigationBarTintColor = giniConfigurationProxy.navigationBarTintColor {
            self.navigationBarTintColor = navigationBarTintColor
        }
        
        if let navigationBarTitleColor = giniConfigurationProxy.navigationBarTitleColor {
            self.navigationBarTitleColor = navigationBarTitleColor
        }
        
        if let navigationBarTitleFont = giniConfigurationProxy.navigationBarTitleFont {
            self.navigationBarTitleFont = navigationBarTitleFont
        }
    }
}
