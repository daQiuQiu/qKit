//
//  VoteTIEModel.swift
//  ATPKit
//
//  Created by yiren on 2018/11/19.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit

@objcMembers class VoteTIEModel: NSObject {
    var language: String = ""
    var creatives: [String] = []
    var options: [String] = []
    var optionsText: [String] = []
    var message: String = ""
    var question: String = ""
    var placeholder: String = ""
    var titletext: String = ""
    var isInteracted: Bool = false
    
    init(dic:[String:Any]) {
        super.init()
        self.setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
