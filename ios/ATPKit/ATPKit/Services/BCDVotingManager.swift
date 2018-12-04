//
//  BCDVotingManager.swift
//  ATPKit
//
//  Created by Bill Lv on 2018/8/31.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation


public class BCDVotingManager:ATPManagerProtocol {
    
    //MARK: ---------Variables------------
    fileprivate var atpConfig: ATPConfig?
    fileprivate var nasAddress: String?
    fileprivate var contractAddress: String?
    fileprivate var tie: TIE?
    
    public func initSDK(atpConfig: ATPConfig) {
        self.atpConfig = atpConfig
        BCDelegateAPI.setup(baseEP: atpConfig.baseEP)
    }
    
    @objc public func register(nasAddress: String, completion: @escaping (BCDVoteData?) -> Void, failure: @escaping (String?) -> Void) throws {
        let campaignID = (atpConfig?.campaignID)!
        let account = BCDAccount.init()
        account.setupData(nasAddress: nasAddress, campaignID: campaignID)
        try BCDelegateAPI.sharedInstance.register(account
            , completion: { response in
                
                if let registerDic = response {
                    print(registerDic["success"] as! Bool)
                    if registerDic["success"] as! Bool {
                        self.nasAddress = nasAddress
                        let data = registerDic["data"] as! [String: Any]
                        let contractAddress = data["contract"] as! String
                        debugPrint("contract address", contractAddress)
                        self.contractAddress = contractAddress
                        //obtainTIE
                        try! BCDelegateAPI.sharedInstance.getTIE(nasAddress, contractAddress, campaignID, completion: { rs in
                            if let dic = rs {
                                print(dic["success"] as! Bool)
                                
                                if dic["success"] as! Bool {
                                    let secondLayer = dic["data"] as! [String: Any]
                                    let state = secondLayer["state"] as! String
                                    if state == "END" {
                                        let dataDecodedString = String(data: Data(base64Encoded: secondLayer["data"] as! String)!, encoding: .utf8)!.replacingOccurrences(of: "\\", with: "")
                                        print("END MSG = \(dataDecodedString)")
                                        self.tie = self.setTIE(type: .error, raw: ATPKitErrorMsg.end)
                                        failure(ATPKitErrorMsg.end)
                                    } else {
                                        self.tie = self.setTIE(type: .error, raw: secondLayer["data"] as! String)
                                        let voteData = self.parseTIE(tie: self.tie!) as! BCDVoteData?
                                        completion(voteData)
                                    }
                                } else {
                                    let errorMsg = dic["errorMsg"] as! String
                                    self.tie = self.setTIE(type: .error, raw: errorMsg)
                                    failure(errorMsg)
                                }
                            }
                        }, failure: {error in
                            failure(error.debugDescription)
                        }
                        )
                    } else {
                        let errorMsg = registerDic["errorMsg"] as! String
                        self.tie = self.setTIE(type: .error, raw: errorMsg)
                        failure(errorMsg)
                    }
                } else {
                    self.tie = nil
                    failure("register response error")
                }
        }, failure: {error in
            failure(error.debugDescription)
        })
    }
    
    public func delegateInteract(atpEvent: AnyObject, completion: @escaping (NSDictionary?) -> Void, failure: @escaping (String?) -> Void) throws {
        try BCDelegateAPI.sharedInstance.vote(atpEvent as! BCDVote, completion: { response in
            if let dic = response {
                if dic["success"] as! Bool {
//                    print("INTERACT response = \(dic)")
                    let result = dic["data"] as! NSDictionary
                    completion(result)
                }else {
                    let errorMsg = dic["errorMsg"] as! String
//                    print("error! = \(errorMsg)")
                    failure(errorMsg)
                }
            }
        }, failure: { error in
            failure(error.debugDescription)
        })
    }
    
    private func setTIE(type:TIEType, raw: String) -> TIE {
        let tie = TIE.init()
        tie.setupData(type: type, raw: raw)
        return tie
    }
    
    private func parseTIE(tie: TIE) -> AnyObject? {
        let dataEnc = tie.raw
        let dataDecodedString = String(data: Data(base64Encoded: dataEnc)!, encoding: .utf8)!.replacingOccurrences(of: "\\", with: "")
//        debugPrint("data decoded string", dataDecodedString)
        if let firstLayerJson = try? JSONSerialization.jsonObject(with: dataDecodedString.data(using: .utf8)!) as! NSArray {
//            debugPrint("firstLayerJson", firstLayerJson)
            let lang = getLang(lang: atpConfig?.lang, defaultLang: "en")
            var objs = firstLayerJson.filter{($0 as! [String: Any])["language"] as! String == lang}
            if lang == "en" {
                if objs.count == 0 {
                    return nil
                }
            } else {
                objs = firstLayerJson.filter{($0 as! [String: Any])["language"] as! String == "en"}
                if objs.count == 0 {
                    return nil
                }
            }
            
            let secondLayerJson = objs[0] as! [String: Any]
            debugPrint("obj", secondLayerJson)
            let question = secondLayerJson["question"] as! String
            let options = secondLayerJson["options"] as! NSArray
            let optionsText = secondLayerJson["optionsText"] as! NSArray
            let message = secondLayerJson["message"] as! String
            debugPrint("question", question)
            debugPrint("options", options)
            debugPrint("message", message)
            var opts: Array<String> = Array()
            for (index, element) in options.enumerated() {
                let va = valArray(arr: optionsText, index: index)
                let v = val(value: va, defaultValue: element as! String)
                opts.append(v)
            }
            let msg = val(value: atpConfig?.msg, defaultValue: message)
            let votedatap = BCDVoteData.init()
            votedatap.setupData(question: question, options: opts , message: msg)
            return votedatap
        }
        return nil
    }
    
    private func getLang(lang: String?, defaultLang: String) -> String {
        guard let vlang = lang else {
            return defaultLang
        }
        return vlang
    }
    
    private func valArray(arr: NSArray, index: Int) -> String? {
        if arr.count - 1 < index {
            return nil
        }
        return arr[index] as? String
    }
    
    private func val(value: String?, defaultValue: String) -> String {
        guard let v = value else {
            return defaultValue
        }
        return v
    }
    
    public func dispatch(adForm: Any?) -> ATPRenderer? {
        if tie == nil {
            return nil
        }
        switch tie!.type {
        case .delegate:
            return ATPDelegateVotingRender()
        case .none:
            return nil
        case .error:
            return nil
        case .original:
            return ATPDelegateVotingRender()
        }
    }
    
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
