//
//  BCDAccount.swift
//  Renderer
//
//  Created by Bill Lv on 2018/9/1.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation

//public struct BCDAccount: Codable {
//    let nasAddress: String
//    let campaignID: String
//    
//    public init(nasAddress: String, campaignID: String) {
//        self.nasAddress = nasAddress
//        self.campaignID = campaignID
//    }
//}

public class BCDAccount: NSObject {
    @objc public var campaignID: String = ""
    @objc public var nasAddress: String = ""
    
    @objc public func setupData(nasAddress: String, campaignID: String) {
        self.nasAddress = nasAddress
        self.campaignID = campaignID
    }
}
