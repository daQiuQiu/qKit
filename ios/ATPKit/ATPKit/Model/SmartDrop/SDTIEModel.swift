//
//  SDTIEModel.swift
//  ATPKit
//
//  Created by yiren on 2018/11/15.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit

@objcMembers class SDTIEModel: NSObject {
    var language: String = ""
    var creatives: [String] = []
    var message: String = ""
    var checkboxText: String = ""
    var isInteracted: Bool = false
    
    init(dic:[String:Any]) {
        super.init()
        self.setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
