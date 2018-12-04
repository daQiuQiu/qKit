//
//  ATPBaseView.swift
//  ATPKit
//
//  Created by yiren on 2018/11/19.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit

class ATPBaseView: UIView {
    
    public var language: Int?

    public func getI18NString(key:String) -> String {
        return Bundle.getATPLocalizedString(forkey: key, type: self.language)
    }
}
