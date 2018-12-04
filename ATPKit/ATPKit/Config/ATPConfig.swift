//
//  ATPConfig.swift
//  ATPKit
//
//  Created by Bill Lv on 2018/8/31.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation

//public struct ATPConfig: Codable {
//    let baseEP: String
//    let campaignID: String
//    let lang: String
//    let accid: String?
//    let msg: String?
//
//    public init(baseEP: String, campaignID: String, lang: String = "en", accid: String? = nil, msg: String? = nil) {
//        self.baseEP = baseEP
//        self.campaignID = campaignID
//        self.lang = lang
//        self.accid = accid
//        self.msg = msg
//    }
//}

public class ATPConfig: NSObject {
    var baseEP: String = ""
    var campaignID: String = ""
    var lang: String = ""
    var accid: String?
    var msg: String?
    
    
    
   public func setupData(baseEP: String, campaignID: String, lang: String = "en", accid: String? = nil, msg: String? = nil) {
        self.baseEP = baseEP
        self.campaignID = campaignID
        self.lang = lang
        self.accid = accid
        self.msg = msg
    }
}

public class BCIConfig:NSObject {
    //MARK:原生互动参数
    @objc public var language: Int = 0
    @objc public var partnerID: String = ""
    
    @objc public init(language:Int, partnerID:String) {
        self.language = language
        self.partnerID = partnerID
        
        super.init()
    }
    
    @objc public func setupConfig(language:Int, partnerID:String) {
        self.language = language
        self.partnerID = partnerID
    }
}
