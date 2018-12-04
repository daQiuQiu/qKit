//
//  Vote.swift
//  Renderer
//
//  Created by Bill Lv on 2018/8/29.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation

public class BCDVote: NSObject {
    @objc public var nasAddress: String = ""
    @objc public var campaignID: String = ""
    @objc public var index: String = ""
    @objc public var answer: String = ""
    
   @objc public func setupData(nasAddress: String
        , campaignID: String
        , index: String = "1"
        , answer: String = "1") {
        self.nasAddress = nasAddress
        self.campaignID = campaignID
        self.index = index
        self.answer = answer
    }
}
