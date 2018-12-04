//
//  ATPConstants.swift
//  ATPKit
//
//  Created by yiren on 2018/11/1.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation
import UIKit


//Constants
public let kScreenHeight = UIScreen.main.bounds.size.height
public let kScreenWidth = UIScreen.main.bounds.size.width
public let kWidthRate = UIScreen.main.bounds.size.width / 375.0
public let kHeightRate = UIScreen.main.bounds.size.height / 667.0
public let isIphoneX = kScreenHeight >= 812 ? true : false


public func ATPSetColor(R:CGFloat,G:CGFloat,B:CGFloat,A:CGFloat) -> UIColor{
    return UIColor.init(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: A)
}

func kColorFromHex(rgbValue: Int) -> (UIColor) {
    
    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                   alpha: 1.0)
}



#if DEBUG
#else
func print(object: Any) {}
func println(object: Any) {}
func println() {}

func NSLog(format: String, args: CVarArgType...) {}
#endif

public class ATPConstants {
    public static let testnet = "https://testnet.nebulas.io/"
    public static let mainnet = "https://mainnet.nebulas.io/"
    public static let explorerTest = "https://explorer.nebulas.io/#/testnet/tx/"
    public static let explorerMain = "https://explorer.nebulas.io/#/tx/"
}
