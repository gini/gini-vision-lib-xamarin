//
//  ExtractionProxy.swift
//  GVLProxy
//
//  Created by Maciej Trybilo on 07.05.20.
//  Copyright © 2020 Gini GmbH. All rights reserved.
//

import Foundation
import Gini

@objc(ExtractionProxy)
public class ExtractionProxy: NSObject {
    
    /// The extraction's box. Only available for some extractions.
    @objc public let box: BoxProxy?
    
    /// The available candidates for this extraction.
    @objc public let candidates: String?
    
    /// The extraction's entity.
    @objc public let entity: String
    
    /// The extraction's value
    @objc public var value: String
    
    /// The extraction's name
    @objc public var name: String?
    
    @objc public init(box: BoxProxy?, candidates: String?, entity: String, value: String, name: String?) {
        
        self.box = box
        self.candidates = candidates
        self.entity = entity
        self.value = value
        self.name = name
        
        super.init()
    }
    
    convenience init(extraction: Extraction) {
        self.init(box: BoxProxy(box: extraction.box),
                  candidates: extraction.candidates,
                  entity: extraction.entity,
                  value: extraction.value,
                  name: extraction.name)
    }
}

extension ExtractionProxy {
    
    @objc(BoxProxy)
    public class BoxProxy: NSObject {
        @objc public let height: Double
        @objc public let left: Double
        @objc public let page: Int
        @objc public let top: Double
        @objc public let width: Double
        
        @objc public init(height: Double,
                          left: Double,
                          page: Int,
                          top: Double,
                          width: Double) {
            
            self.height = height
            self.left = left
            self.page = page
            self.top = top
            self.width = width
            
            super.init()
        }
        
        convenience init?(box: Extraction.Box?) {
            
            guard let box = box else { return nil }
            
            self.init(height: box.height,
                      left: box.left,
                      page: box.page,
                      top: box.top,
                      width: box.width)
        }
    }
}
