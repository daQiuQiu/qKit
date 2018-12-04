//
//  BCDelegateAPI.swift
//  ATPKit
//
//  Created by Bill Lv on 8/22/18.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit
//import Renderer

public class BCDelegateAPI: NSObject {
    // MARK: - Singleton Pattern
    public static let sharedInstance = BCDelegateAPI()
    private static let setup = BCDelegateAPIHolder()
    
    public class func setup(baseEP: String) {
        BCDelegateAPI.setup.baseEP = baseEP
    }
    
    // MARK: - Variables
    fileprivate var httpClient: ATPHTTPClient
    
    fileprivate override init() {
        let baseEP = BCDelegateAPI.setup.baseEP
        guard baseEP != nil else {
            fatalError("Error - you must call setup before accessing BCDelegateAPI.sharedInstance")
        }
        
        httpClient = ATPHTTPClient(baseEP: baseEP!)
        super.init()
    }
    
    // MARK: - Public API
    //get
    public func getTIE(_ nasAddr: String, _ contractAddr: String, _ campaignID: String
        , completion: @escaping (NSDictionary?) -> Void,failure: @escaping (Error?) -> Void) throws {
        try httpClient.getRequest("/tie?nasAddr=\(nasAddr)&contractAddr=\(contractAddr)&campaignID=\(campaignID)", completion: completion, failure: failure)
    }
    
    public func vote(_ vote: BCDVote, completion: @escaping (NSDictionary?) -> Void,failure: @escaping (Error?) -> Void) throws {
        let dic = ["nasAddress":vote.nasAddress,
                   "campaignID":vote.campaignID,
                   "index":vote.index,
                   "answer":vote.answer]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            try httpClient.postRequest("/interact", body: jsonString, completion: completion, failure: failure)
        }
    }
    
    public func register(_ account: BCDAccount, completion: @escaping (NSDictionary?) -> Void,failure: @escaping (Error?) -> Void) throws {
        let dic = ["campaignID":account.campaignID,
                   "nasAddress":account.nasAddress]
        if let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            try httpClient.postRequest("/sae/signup", body: jsonString, completion: completion, failure: failure)
        }
    }
    //get
    public func getReceipt(_ txid:String, completion: @escaping (NSDictionary?) -> Void,failure: @escaping (Error?) -> Void) throws {
        try httpClient.getRequest("/transaction-receipt/message/\(txid)", completion: completion, failure: failure)
    }
    
}

private class BCDelegateAPIHolder {
    var baseEP: String?
}
