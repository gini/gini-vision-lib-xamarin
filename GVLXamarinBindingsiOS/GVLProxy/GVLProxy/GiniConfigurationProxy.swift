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
    
    /**
     Can be turned on during development to unlock extra information and to save captured images to camera roll.
     
     - warning: Should never be used outside of a development enviroment.
     */
    @objc public var debugModeOn = false
    
    /**
     Set the types supported by the file import feature. `GiniVisionImportFileTypes.none` by default
     
     */
    @objc public var fileImportSupportedTypes: GiniConfigurationProxy.GiniVisionImportFileTypesProxy = .none
    
    /**
     Indicates whether the flash toggle should be shown in the camera screen.
     
     */
    @objc public var flashToggleEnabled = false
    
    /**
     Indicates whether the open with feature is enabled or not. In case of `true`,
     a new option with the open with tutorial wil be shown in the Help menu
     */
    @objc public var openWithEnabled = false
    
    /**
     Indicates whether the QR Code scanning feature is enabled or not.
     */
    @objc public var qrCodeScanningEnabled = false
    
    /**
     Indicates whether the multipage feature is enabled or not. In case of `true`,
     multiple pages can be processed, showing a different review screen when capturing.
     */
    @objc public var multipageEnabled = false
    
    /**
     Sets the tint color of all navigation items in all screens of the Gini Vision Library to
     the globally specified color.
     
     - note: Screen API only.
     */
    @objc public var navigationBarItemTintColor = UINavigationBar.appearance().tintColor
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
        
        debugModeOn = giniConfigurationProxy.debugModeOn
        fileImportSupportedTypes = GiniConfiguration.GiniVisionImportFileTypes(giniVisionImportFileTypesProxy: giniConfigurationProxy.fileImportSupportedTypes)
        flashToggleEnabled = giniConfigurationProxy.flashToggleEnabled
        openWithEnabled = giniConfigurationProxy.openWithEnabled
        qrCodeScanningEnabled = giniConfigurationProxy.qrCodeScanningEnabled
        multipageEnabled = giniConfigurationProxy.multipageEnabled
        navigationBarItemTintColor = giniConfigurationProxy.navigationBarItemTintColor
    }
}
