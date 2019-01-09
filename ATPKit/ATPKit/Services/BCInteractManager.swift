//
//  BCInteractManager.swift
//  ATPKit
//
//  Created by yiren on 2018/11/1.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation

public class BCInteractManager {
    fileprivate var bciConfig: BCIConfig?
    public var nasAddress: String?
    public var contractAddress: String?
    
    public func setSDK(bciConfig: BCIConfig) {
        self.bciConfig = bciConfig
    }
    
    public func getTIE(payload:String, completion: @escaping (NSDictionary?) -> Void, failure:@escaping (String?) -> Void) throws{
        if let toAddress = parsePayload(payload: payload) {
            
            let count = toAddress.count
            if count < 35 && count > 42 {//invalid address
                failure(ATPKitErrorMsg.invalidNasAddress)
                return
            }
            
            guard let fromAddress = nasAddress else {
                return
            }
            //创建请求参数
            let args:Array = [fromAddress]
            let functions:NSDictionary = ["function":"getTIE",
                                          "args":"\(args)"]
            
            let dic:NSDictionary = ["from":fromAddress,
                                    "to":toAddress,
                                    "value":"0",
                                    "gasPrice":"1000000",
                                    "gasLimit":"2000000",
                                    "contract":functions]
            //jsonrpc call
            try BCInteractAPI.sharedInstance.nasCall(dic , completion: { result in
                //            print("receive from contract:\(result!)")
                let dataDic = result as! [String:Any]
                let resultDic = dataDic["result"] as? [String:Any]
                print("getTIE resultDIC = \(result!)")
                if let parseDic = self.dataParseForTIE(tie: resultDic as Any) {
                    if let errMsg = parseDic["error"] as? String {
                        failure(errMsg)
                    }else {
                        if let firstLayer = parseDic["result"] as? [String:Any] {
                            if let isInteract = firstLayer["Interacted"] as? Bool {
                                if let secondLayer = firstLayer["TIE"] as? [String:Any] {
                                    if let type = secondLayer["type"] as? String {
                                        if let respArray:Array = (secondLayer["content"] as? [Dictionary<String,Any>]) {
                                            var tieDic:[String:Any]?
                                            
                                            for dic in respArray {//获取对应语言
                                                if let lang = dic["language"] as? String {
                                                    if lang == self.getLang(config: self.bciConfig!) {
                                                        tieDic = ["type":type,"tie":dic,"interacted":isInteract]
                                                    }
                                                }
                                            }
                                            if tieDic != nil {//没有对应语言 取EN
//                                                print("lang1 = \(tieDic)")
                                                completion(tieDic! as NSDictionary)
                                            }else {
                                                for dic in respArray {
                                                    if let lang = dic["language"] as? String {
                                                        if lang == "en" {
                                                            tieDic = ["type":type,"tie":dic,"interacted":isInteract]
                                                        }
                                                    }
                                                }
                                                if tieDic != nil {//没有对应语言 取第一个
                                                    completion(tieDic! as NSDictionary)
                                                }else {
                                                    if respArray.count > 0 {//设置默认语言
                                                        let dic = respArray[0] as [String:Any]
                                                        tieDic = ["type":type,"tie":dic,"interacted":isInteract]
                                                        completion(tieDic! as NSDictionary)
                                                    }else {
                                                        failure("no language type from TIE")
                                                    }
                                                    
                                                }
                                                
                                            }
                                        }else {
                                            failure("Invaid TIE Tier1")
                                        }
                                    }else {
                                        failure("wrong TIE type")
                                    }
                                }else {
                                    failure("Invaid TIE Tier2")
                                }
                            }else {
                                failure("Invaid TIE Tier3")
                            }
                        }else {
                            failure("Invaid TIE Tier4")
                        }
                    }
                }else {
                    failure("TIE PARSING FAIL")
                }
            }, failure: { error in
                failure(Bundle.getATPLocalizedString(forkey: "网络连接失败,请稍后再试", type: ATPKit.sharedInstance.lang))
            })
        }else {
            failure("Payload Error")
        }
    }
    
    public func nasSendRawTransaction(signedData:String,completion: @escaping (NSDictionary?) -> Void, failure:@escaping (String?) -> Void) throws {
        let dic:NSDictionary = ["data":signedData]
        try BCInteractAPI.sharedInstance.nasSendRawTransaction(dic, completion: { result in
            let dict = result as! [String:Any]
            
            if let errormsg = dict["error"] as? String {
//                print("error from sendRaw = \(errormsg)")
                failure(errormsg)
            }else {
                if let receipt = dict["result"] as? [String:Any] {
                    completion(receipt as NSDictionary)
                }else {
//                    print("getReceiptJsonError")
                    failure("getReceiptJsonError")
                }
            }
        }, failure: { error in
            failure(Bundle.getATPLocalizedString(forkey: "网络连接失败,请稍后再试", type: ATPKit.sharedInstance.lang))
        })
        
    }
    
    public func nasGetReceipt(transactionHash:String,completion: @escaping (NSDictionary?) -> Void, failure:@escaping (String?) -> Void) throws {
        let dic:NSDictionary = ["hash":transactionHash]
        try BCInteractAPI.sharedInstance.nasGetTransactionReceipt(dic, completion: { result in
            let dict = result as! [String:Any]
            if let errormsg = dict["error"] as? String {
                failure(errormsg)
            }else {
                if let receipt = dict["result"] as? [String:Any] {
                    completion(receipt as NSDictionary)
                }else {
                    failure("getReceiptJsonError")
                }
            }
        }, failure: { error in
            failure(Bundle.getATPLocalizedString(forkey: "网络连接失败,请稍后再试", type: ATPKit.sharedInstance.lang))
//            print("ERRORRORR!! = \(String(describing: error))")
        })
    }
    
    public func chechReceipt(fromAddress: String, completion: @escaping (NSDictionary?) -> Void, failure:@escaping (String?) -> Void) throws {
        //parameters
        let args:Array = [fromAddress]
        let functions:NSDictionary = ["function":"getReceipt",
                                      "args":"\(args)"]
        if let toAddress = contractAddress {
            let dic:NSDictionary = ["from":fromAddress,
                                    "to":toAddress,
                                    "value":"0",
                                    "gasPrice":"1000000",
                                    "gasLimit":"2000000",
                                    "contract":functions]
            
            try BCInteractAPI.sharedInstance.nasCall(dic, completion: { (result) in
                if let dic = self.dataParseForTIE(tie: result as Any) {
                    print("receipt = \(dic)")
                    if let firstLayer = dic["result"] as? [String:Any] {
                        if let secondLayer = firstLayer["result"] as? [String:Any] {
                            completion(secondLayer as NSDictionary)
                        }else {
                            failure("wrong receipt tier2")
                        }
                    }else {
                        failure("wrong receipt tier1")
                    }
                }else {
                    failure("TIE PARSING FAIL")
                }
            }, failure:{ (error) in
                failure(Bundle.getATPLocalizedString(forkey: "网络连接失败,请稍后再试", type: ATPKit.sharedInstance.lang))
            })
        }else {
            failure("NO CONTRACT")
        }
        
    }
    
    public func isRenderable(payload:String?) -> Bool {
        if let dPayload = payload {
            let data = Data(base64Encoded: dPayload, options: Data.Base64DecodingOptions(rawValue: 0))
            let dataDecodedString = data?.hexEncodedString()
//            print("decode String = \(String(describing: dataDecodedString))")
            if let decodeStr = dataDecodedString {
                let index = decodeStr.index((decodeStr.startIndex), offsetBy: 4)
                if  decodeStr.count > 4 {
                    let prefixStr = decodeStr[0..<4]
                    if prefixStr == "ae01" {
                        let contractAddr = String(decodeStr.suffix(from: index))
                        let conData = Data(fromHexEncodedString: contractAddr)
//                        print("address = \(String(describing: String(data: conData!, encoding: String.Encoding.utf8)))")
                        if let address = String(data: conData!, encoding: String.Encoding.utf8) {
//                            print("address = \(address)")
                            return true
                        }else {
                            return false
                        }
                    }else {
                        return false
                    }
                }else {
                    return false
                }
            }else {
                return false
            }
        }else {
            return false
        }
    }
    
    public func parsePayload(payload:String?) -> String? {
        if let dPayload = payload {
            let data = Data(base64Encoded: dPayload, options: Data.Base64DecodingOptions(rawValue: 0))
            let dataDecodedString = data?.hexEncodedString()
//            print("decode String = \(String(describing: dataDecodedString))")
            if let decodeStr = dataDecodedString {
                if  decodeStr.count > 4 {
                    let index = decodeStr.index((decodeStr.startIndex), offsetBy: 4)
                    let prefixStr = decodeStr[0..<4]
                    if prefixStr == "ae01" {
                        let contractAddr = String(decodeStr.suffix(from: index))
                        let conData = Data(fromHexEncodedString: contractAddr)
//                        print("address = \(String(describing: String(data: conData!, encoding: String.Encoding.utf8)))")
                        if let address = String(data: conData!, encoding: String.Encoding.utf8) {
//                            print("address = \(address)")
                            return address
                        }else {
                            return nil
                        }
                    }else {
                        return nil
                    }
                }else {
                    return nil
                }
            }else {
                return nil
            }
            
        }else {
            return nil
        }
    }
    //转义TIE
    private func dataParseForTIE(tie:Any) -> [String:Any]? {
        if let dic = tie as? NSDictionary{
            let data = try? JSONSerialization.data(withJSONObject: dic as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            var dataDecodedString = String(data: data!, encoding: .utf8)!.replacingOccurrences(of: "\\", with: "")
            dataDecodedString = dataDecodedString.replacingOccurrences(of: "\"\"{", with: "{")
            dataDecodedString = dataDecodedString.replacingOccurrences(of: "}\"\"", with: "}")
//            print("TIEDecodeed: \(dataDecodedString)")
            let datatodic = dataDecodedString.data(using: String.Encoding.utf8)
            let parsedDict = try? JSONSerialization.jsonObject(with: datatodic!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
            
            return parsedDict
        }else {
            return nil
        }
    }
    
    private func getLang(config:BCIConfig) -> String {
        switch config.language {
        case ATPLanguageType.CN.rawValue:
            return "cn"
        case ATPLanguageType.EN.rawValue:
            return "en"
        case ATPLanguageType.KR.rawValue:
            return "kr"
        default:
            return "en"
        }
    }
}


