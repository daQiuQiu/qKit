//
//  BCITransactionInfo.swift
//  ATPKit
//
//  Created by yiren on 2018/11/5.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit

@objc public class BCITransactionInfo: NSObject {
    @objc public var contractAddress: String = ""
    @objc public var fromAddress: String = ""
    @objc public var functionName: String = ""
    @objc public var args: [String] = []
    
    @objc public func setupData(contractAddress: String
        , functionName: String, fromAddress: String
        , args: [String]) {
        self.contractAddress = contractAddress
        self.functionName = functionName
        self.fromAddress = fromAddress
        self.args = args
    }
}
