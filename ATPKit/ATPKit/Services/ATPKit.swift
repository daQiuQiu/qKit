//
//  KitFactory.swift
//  ATPKit
//
//  Created by Bill Lv on 2018/8/31.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation
import UIKit

@objc public class ATPKit: NSObject {
    @objc public static let sharedInstance = ATPKit()
    private static let setup = KitFactoryHolder()
    var kitBuilder: BCDelegateKit?
    var bcinteractKit:BCInteractKit?
    var atpType:Int?
    var lang:Int = 0
    var isDebug:Bool = true
    var loadingView:UIView?
    
    @objc public class func setup(type: Int) {
        ATPKit.setup.type = type
    }
    
    fileprivate override init() {
        let type = ATPKit.setup.type
        self.atpType = type
        guard type != nil else {
            fatalError("Error - you must call setup before accessing KitFactory.sharedInstance")
        }
        if type == TIEType.delegate.rawValue {
           kitBuilder = BCDelegateKit(type: type!)
        }else {
           bcinteractKit = BCInteractKit()
        }
        
        super.init()
    }
    
    @objc public func setDebugMode(debugMode:Bool) {
        isDebug = debugMode
        #if DEBUG
        print("setdebugmode")
        #endif
    }
    
    public func getBCDelegateKit() -> BCDelegateKit? {
        if atpType != TIEType.delegate.rawValue  {
            fatalError("Error - you must set correct TIEType")
        }
        return kitBuilder
    }
    @objc public func getBCinteractKit() -> BCInteractKit? {
        if atpType != TIEType.original.rawValue  {
            fatalError("Error - you must set correct TIEType")
        }
        return bcinteractKit
    }
    @objc public func displayLoadingView() {
        let window = UIApplication.shared.keyWindow!
        self.loadingView = ATPKit.displaySpinner(onView: window)
    }
    @objc public func hideLoadingView() {
        if self.loadingView != nil {
            ATPKit.removeSpinner(spinner: self.loadingView!)
        }
    }
}

private class KitFactoryHolder {
    var type: Int?
}
