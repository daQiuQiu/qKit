//
//  BCInteractAPI.swift
//  ATPKit
//
//  Created by yiren on 2018/11/1.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit

class BCInteractAPI: NSObject {
    public static let sharedInstance = BCInteractAPI()
    fileprivate var httpClient: ATPHTTPClient
    
    
    fileprivate override init() {
        if ATPKit.sharedInstance.isDebug {
            httpClient = ATPHTTPClient(baseEP: ATPConstants.testnet)
        }else {
            httpClient = ATPHTTPClient(baseEP: ATPConstants.mainnet)
        }
        
        super.init()
    }
    
    public func nasCall(_ parameters: NSDictionary, completion: @escaping (NSDictionary?) -> Void,failure: @escaping (Error?) -> Void) throws {
        let dic = parameters
        if let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            try httpClient.postRequest("v1/user/call", body: jsonString, completion: completion, failure: failure)
        }
    }
    
    public func nasSendRawTransaction(_ parameters: NSDictionary, completion: @escaping (NSDictionary?) -> Void,failure: @escaping (Error?) -> Void) throws {
        print("send raw???")
        let dic = parameters
        if let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            try httpClient.postRequest("v1/user/rawtransaction", body: jsonString, completion: completion, failure: failure)
        }
    }
    
    public func nasGetTransactionReceipt(_ parameters: NSDictionary, completion: @escaping (NSDictionary?) -> Void,failure: @escaping (Error?) -> Void) throws {
        let dic = parameters
        if let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            try httpClient.postRequest("v1/user/getTransactionReceipt", body: jsonString, completion: completion, failure: failure)
        }
    }
    
}
