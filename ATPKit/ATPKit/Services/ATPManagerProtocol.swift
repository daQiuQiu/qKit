//
//  ATPManager.swift
//  ATPKit
//
//  Created by Bill Lv on 2018/8/31.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation


public protocol ATPManagerProtocol {
    func initSDK(atpConfig: ATPConfig)
    
    func register(nasAddress: String, completion: @escaping (BCDVoteData?) -> Void,failure:@escaping (String?) -> Void) throws
    
    func dispatch(adForm: Any?) -> ATPRenderer?
    
    func delegateInteract(atpEvent: AnyObject, completion: @escaping (NSDictionary?) -> Void,failure:@escaping (String?) -> Void) throws
}

@objc public protocol ATPKitErrorCallBack {
    func errorHandle(source: String?, errorMsg:String?)
}

@objc public protocol ATPKitCallBack {
    func emitEvent(transactionInfo:BCITransactionInfo)
}

public protocol ATPTransactionCallBack:AnyObject {
    func receiveTransaction(signedTransaction:String)
}

public protocol ATPRenderer {
    func render()
    
    func emitEvent(atpEvent: Any)
    
    func dispose()
}

public protocol ATPDelegateVotingRenderDelegate:AnyObject {
    func register(nasAddress: String, completion: @escaping (BCDVoteData?) -> Void,failure: @escaping (String?) -> Void)
    
    func interact(vote: BCDVote, completion:@escaping (String?) ->Void,failure: @escaping (String?) -> Void)
}



