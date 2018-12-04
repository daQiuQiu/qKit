//
//  BCIPayloadConfig.swift
//  ATPKit
//
//  Created by yiren on 2018/11/6.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit

public class BCIPayloadConfig: NSObject {
    @objc public var payload: String = ""
    @objc public var fromAddress: String = ""
    
    @objc public init(payload: String
        , fromAddress: String) {
        self.payload = payload
        self.fromAddress = fromAddress
        
        super.init()
    }
    
    @objc public func setupData(payload: String
        , fromAddress: String) {
        self.payload = payload
        self.fromAddress = fromAddress
        
    }
}
