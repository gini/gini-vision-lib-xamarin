//
//  SimplePreferredButtonResource.swift
//  GVLProxy
//
//  Created by Maciej Trybilo on 25.05.20.
//  Copyright © 2020 Gini GmbH. All rights reserved.
//

import Foundation
import GiniVision

@objc(SimplePreferredButtonResource)
public class SimplePreferredButtonResource: NSObject, PreferredButtonResource {
    
    @objc public var preferredImage: UIImage?
    @objc public var preferredText: String?
    
    @objc public init(preferredImage: UIImage?, preferredText: String?) {
        
        self.preferredImage = preferredImage
        self.preferredText = preferredText
        
        super.init()
    }
}
