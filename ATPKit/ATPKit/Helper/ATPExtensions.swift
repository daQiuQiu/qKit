//
//  ATPExtensions.swift
//  ATPKit
//
//  Created by yiren on 2018/11/5.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation
import UIKit

public extension Data {
    private static let hexAlphabet = "0123456789abcdef".unicodeScalars.map { $0 }
    
    func hexEncodedString() -> String {
        return String(self.reduce(into: "".unicodeScalars, { (result, value) in
            result.append(Data.hexAlphabet[Int(value/16)])
            result.append(Data.hexAlphabet[Int(value%16)])
        }))
    }
    
    init?(fromHexEncodedString string: String) {
        // Convert 0 ... 9, a ... f, A ...F to their decimal value,
        // return nil for all other input characters
        func decodeNibble(u: UInt16) -> UInt8? {
            switch(u) {
            case 0x30 ... 0x39:
                return UInt8(u - 0x30)
            case 0x41 ... 0x46:
                return UInt8(u - 0x41 + 10)
            case 0x61 ... 0x66:
                return UInt8(u - 0x61 + 10)
            default:
                return nil
            }
        }
        self.init(capacity: string.utf16.count/2)
        var even = true
        var byte: UInt8 = 0
        for c in string.utf16 {
            guard let val = decodeNibble(u: c) else { return nil }
            if even {
                byte = val << 4
            } else {
                byte += val
                self.append(byte)
            }
            even = !even
        }
        guard even else { return nil }
    }
}

public extension Bundle {
    
    class func getATPLocalizedString(forkey key:String, type:Int?) -> String {
        if let langType = type {
            let setLang = getATPLanguage(forType: langType)
            //        let localBundle = getLocalBundle()
            if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/\(setLang)", ofType: "lproj") {
                if let bundle = Bundle.init(path: path) {
                    let value = bundle.localizedString(forKey: key, value: nil, table: nil)
                    return value
                }else {
                    return key
                }
                
            }else {
                return key
            }
        }else{
//            print("no lang type")
            return key
        }
    }
    
    class func getATPLocalizedString(forkey key:String, type:ATPLanguageType) -> String {
        let setLang = getATPLanguage(forType: type)
        //        let localBundle = getLocalBundle()
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/\(setLang)", ofType: "lproj") {
            
            if let bundle = Bundle.init(path: path) {
                let value = bundle.localizedString(forKey: key, value: nil, table: nil)
                return value
            }else {
                return key
            }
            
        }else {
            return key
        }
    }
    
    class func getATPLanguage(forType type:ATPLanguageType) -> String {
        switch type {
        case .CN:
            return "zh-Hans"
            
        case .KR:
            return "ko"
            
        case .EN:
            return "en"
            
        }
    }
    class func getATPLanguage(forType type:Int) -> String {
        switch type {
        case 0:
            return "zh-Hans"
        case 1:
            return "en"
        case 2:
            return "ko"
        default:
            return "zh-Hans"
        }
    }
}

public extension ATPKit {
    class func displaySpinner(onView: UIWindow) -> UIView {
        let containerView = UIView.init(frame: onView.bounds)
        let spinnerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 120*kWidthRate, height: 120*kWidthRate))
        spinnerView.layer.cornerRadius = 20*kWidthRate
        spinnerView.clipsToBounds = true
        spinnerView.backgroundColor = kColorFromHex(rgbValue: 0x000000).withAlphaComponent(0.6)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        spinnerView.center = containerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            containerView.addSubview(spinnerView)
            onView.addSubview(containerView)
        }
        return containerView
    }
    
    class func removeSpinner(spinner: UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
            
        }
    }
}

public extension UIViewController {
    class func displaySpinner(onView: UIView) -> UIView {
        let containerView = UIView.init(frame: onView.bounds)
        let spinnerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 120*kWidthRate, height: 120*kWidthRate))
        spinnerView.layer.cornerRadius = 20*kWidthRate
        spinnerView.clipsToBounds = true
        spinnerView.backgroundColor = kColorFromHex(rgbValue: 0x000000).withAlphaComponent(0.6)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        spinnerView.center = containerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            containerView.addSubview(spinnerView)
            onView.addSubview(containerView)
        }
        return containerView
    }
    
    class func removeSpinner(spinner: UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
            
        }
    }
}

//test
