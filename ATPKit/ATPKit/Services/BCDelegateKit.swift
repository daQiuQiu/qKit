//
//  BCDelegateKit.swift
//  ATPKit
//
//  Created by Bill Lv on 2018/8/31.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation


@objc public class BCDelegateKit:NSObject {
    
    private var type: Int
    private var atpManager:ATPManagerProtocol?
    @objc weak public var errorDelegate: ATPKitErrorCallBack?
    
    public init(type: Int) {
        self.type = type
        if type == TIEType.delegate.rawValue {
            atpManager = BCDVotingManager()
        } else {
            atpManager = BCDVotingManager()
        }
    }
    
    @objc public func initSDK(atpConfig: ATPConfig) {
        atpManager?.initSDK(atpConfig: atpConfig)
    }
    //MARK:--------------CES Related Method------------------
    @objc public func register(nasAddress: String, completion: @escaping (BCDVoteData?) -> Void, failure: @escaping (String?) -> Void)  {
        let count = nasAddress.count
        if count < 35 && count > 42 {
            self.errorDelegate?.errorHandle(source: ATPErrorSource.register, errorMsg: ATPKitErrorMsg.invalidNasAddress)
            return
        }
        do {
            try atpManager?.register(nasAddress: nasAddress, completion: completion, failure: { error in
                self.errorDelegate?.errorHandle(source: ATPErrorSource.register, errorMsg: error)
                failure(error)
            })
        } catch ATPError.net {
            self.errorDelegate?.errorHandle(source: ATPErrorSource.register, errorMsg: ATPKitErrorMsg.net)
        } catch {
            self.errorDelegate?.errorHandle(source: ATPErrorSource.register, errorMsg: ATPKitErrorMsg.other)
        }
    }
    
    public func dispatch(adForm: Any?) -> ATPRenderer? {
        return atpManager?.dispatch(adForm: adForm)
    }
    
    @objc public func delegateInteract(atpEvent: AnyObject, completion: @escaping (NSDictionary?) -> Void, failure: @escaping (String?) -> Void)  {
        do {
            try atpManager?.delegateInteract(atpEvent: atpEvent, completion: completion, failure: { error in
                self.errorDelegate?.errorHandle(source: ATPErrorSource.interact, errorMsg: error)
                failure(error)
            })
        } catch ATPError.net {
            self.errorDelegate?.errorHandle(source: ATPErrorSource.interact, errorMsg: ATPKitErrorMsg.net)
        } catch {
            self.errorDelegate?.errorHandle(source: ATPErrorSource.interact, errorMsg: ATPKitErrorMsg.other)
        }
        
    }
    
}
