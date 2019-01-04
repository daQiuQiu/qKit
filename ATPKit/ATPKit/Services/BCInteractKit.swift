//
//  BCInteractKit.swift
//  ATPKit
//
//  Created by yiren on 2018/11/2.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit
import Foundation

@objc public class BCInteractKit: NSObject {
    private var bcinteractManager:BCInteractManager?
    @objc weak public var errorDelegate: ATPKitErrorCallBack?
    @objc weak public var interactDelegate: ATPKitCallBack?
    weak public var transactionDelegate: ATPTransactionCallBack?
    private var bciConfig:BCIConfig?
    
    public override init() {
        bcinteractManager = BCInteractManager()
    }
    //MARK: set config
     @objc public func setConfig(bciConfig: BCIConfig) {
        bcinteractManager?.setSDK(bciConfig: bciConfig)
        self.bciConfig = bciConfig
        ATPKit.sharedInstance.lang = bciConfig.language
    }
    //MARK: Blockchain Related
    @objc public func getTIE(payload:String, completion: @escaping (NSDictionary?) -> Void, failure:@escaping (String?) -> Void) {
        do {
            try bcinteractManager?.getTIE(payload: payload, completion: completion, failure: { error in
                self.errorDelegate?.errorHandle(source: "getTIE", errorMsg: error)
                failure(error)
            })
        } catch ATPError.net {
            failure(ATPKitErrorMsg.net)
            CBToast.showToastAction(message: Bundle.getATPLocalizedString(forkey: "网络连接失败,请稍后再试", type: ATPKit.sharedInstance.lang) as NSString)
            self.errorDelegate?.errorHandle(source: ATPErrorSource.register, errorMsg: ATPKitErrorMsg.net)
        } catch {
            failure(ATPKitErrorMsg.other)
            self.errorDelegate?.errorHandle(source: ATPErrorSource.register, errorMsg: ATPKitErrorMsg.other)
        }
        
    }
    
    public func sendRawTransaction(signedData:String, completion: @escaping (NSDictionary?) -> Void, failure:@escaping (String?) -> Void) {
        let isDemo = UserDefaults.standard.bool(forKey:"demomode")
        if isDemo {
            let mockHash = ["txhash":"28c39acc996ddbcf8383799af81abc6c9ac5405443d0c3f1c69997ac77e10efb",
                            "contract_address": ""]
            completion(mockHash as NSDictionary)
            print("demo mode")
            return
        }
        
        do {
            try bcinteractManager?.nasSendRawTransaction(signedData: signedData, completion: completion, failure: { error in
                self.errorDelegate?.errorHandle(source: "sendRawTransaction", errorMsg: error)
                failure(error)
            })
        } catch ATPError.net {
            failure(ATPKitErrorMsg.net)
            CBToast.showToastAction(message: Bundle.getATPLocalizedString(forkey: "网络连接失败,请稍后再试", type: ATPKit.sharedInstance.lang) as NSString)
            self.errorDelegate?.errorHandle(source: ATPErrorSource.register, errorMsg: ATPKitErrorMsg.net)
        } catch {
            failure(ATPKitErrorMsg.other)
            self.errorDelegate?.errorHandle(source: ATPErrorSource.register, errorMsg: ATPKitErrorMsg.other)
        }
    }
    
    public func getReceipt(transactionHash:String, completion: @escaping (NSDictionary?) -> Void, failure:@escaping (String?) -> Void) {
        do {
            try bcinteractManager?.nasGetReceipt(transactionHash: transactionHash, completion: completion, failure: { error in
                self.errorDelegate?.errorHandle(source: "getReceipt", errorMsg: error)
                failure(error)
            })
        } catch ATPError.net {
            failure(ATPKitErrorMsg.net)
            CBToast.showToastAction(message: Bundle.getATPLocalizedString(forkey: "网络连接失败,请稍后再试", type: ATPKit.sharedInstance.lang) as NSString)
            self.errorDelegate?.errorHandle(source: ATPErrorSource.register, errorMsg: ATPKitErrorMsg.net)
        } catch {
            failure(ATPKitErrorMsg.other)
            self.errorDelegate?.errorHandle(source: ATPErrorSource.register, errorMsg: ATPKitErrorMsg.other)
        }
    }
    
    public func checkReceipt(fromAddress: String, completion: @escaping (NSDictionary?) -> Void, failure:@escaping (String?) -> Void) {
        do {
            try bcinteractManager?.chechReceipt(fromAddress: fromAddress, completion: completion, failure: { (error) in
                self.errorDelegate?.errorHandle(source: "checkReceipt", errorMsg: error)
                failure(error)
            })
        } catch ATPError.net {
            failure(ATPKitErrorMsg.net)
            CBToast.showToastAction(message: Bundle.getATPLocalizedString(forkey: "网络连接失败,请稍后再试", type: ATPKit.sharedInstance.lang) as NSString)
            self.errorDelegate?.errorHandle(source: ATPErrorSource.register, errorMsg: ATPKitErrorMsg.net)
        } catch {
            failure(ATPKitErrorMsg.other)
            self.errorDelegate?.errorHandle(source: ATPErrorSource.register, errorMsg: ATPKitErrorMsg.other)
        }
    }
    
    //MARK: Public method
    @objc public func startInteraction(payload:BCIPayloadConfig) {
        let window = UIApplication.shared.keyWindow!
        if let isRender = bcinteractManager?.isRenderable(payload: payload.payload) {
            
            if isRender == true {
                let sv = ATPKit.displaySpinner(onView: window)
                
                let contractAddress = bcinteractManager?.parsePayload(payload: payload.payload)
                bcinteractManager?.nasAddress = payload.fromAddress
                bcinteractManager?.contractAddress = contractAddress
                
                self.getTIE(payload: payload.payload, completion: { [unowned self](result) -> () in
                    ATPKit.removeSpinner(spinner: sv)
                    //init render
                    if let resultDic = result as? [String:Any] {
                        if let renderType = resultDic["type"] as? String {
                            if renderType == "in-wallet smartdrop" {
                                let tieDic = resultDic["tie"] as! [String:Any]
                                let sdVC = ATPSmartDropRender()
                                if let config = self.bciConfig {
                                    sdVC.setConfig(config: config)
                                }else {
//                                    print("no config")
                                }
                                
                                sdVC.fromAddress = payload.fromAddress
                                sdVC.contractAddress = contractAddress
                                let tieModel = SDTIEModel(dic: tieDic)
                                tieModel.isInteracted = resultDic["interacted"] as! Bool
//                                print("tieDic = \(tieDic)")
                                sdVC.setTIEData(tieModel: tieModel)
                                
                                //transition
                                let transition = CATransition()
                                transition.duration = 0.4
                                transition.type = kCATransitionPush
                                transition.subtype = kCATransitionFromRight
                                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                transition.isRemovedOnCompletion = true
                                window.layer.add(transition, forKey: "transitionin")
                                window.rootViewController?.present(sdVC, animated: false, completion: nil)
                            }else if renderType == "in-wallet smartvoting" {
                                let tieDic = resultDic["tie"] as! [String:Any]
//                                print("Vote Dic = \(resultDic)")
                                let voteVC = ATPVotingRenderVC()
                                if let config = self.bciConfig {
                                    voteVC.setConfig(config: config)
                                }else {
//                                    print("no config")
                                }
                                
                                voteVC.fromAddress = payload.fromAddress
                                voteVC.contractAddress = contractAddress
                                let tieModel = VoteTIEModel(dic: tieDic)
                                tieModel.isInteracted = resultDic["interacted"] as! Bool
//                                print("tieDic = \(tieDic)")
                                voteVC.setTIEData(tieModel: tieModel)
                                
                                //transition
                                let transition = CATransition()
                                transition.duration = 0.4
                                transition.type = kCATransitionPush
                                transition.subtype = kCATransitionFromRight
                                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                transition.isRemovedOnCompletion = true
                                window.layer.add(transition, forKey: "transitionin")
                                window.rootViewController?.present(voteVC, animated: false, completion: nil)
                            }else if renderType == "in-wallet feedback" {
                                let tieDic = resultDic["tie"] as! [String:Any]
                                //                                print("Vote Dic = \(resultDic)")
                                let webVC = ATPFeedbackRenderVC()
                                if let config = self.bciConfig {
                                    webVC.setConfig(config: config)
                                }else {
                                    //                                    print("no config")
                                }
                                
                                webVC.fromAddress = payload.fromAddress
                                webVC.contractAddress = contractAddress
                                let tieModel = VoteTIEModel(dic: tieDic)
                                tieModel.isInteracted = resultDic["interacted"] as! Bool
                                //                                print("tieDic = \(tieDic)")
                                webVC.setTIEData(tieModel: tieModel)
                                
                                //transition
                                let transition = CATransition()
                                transition.duration = 0.4
                                transition.type = kCATransitionPush
                                transition.subtype = kCATransitionFromRight
                                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                transition.isRemovedOnCompletion = true
                                window.layer.add(transition, forKey: "transitionin")
                                window.rootViewController?.present(webVC, animated: false, completion: nil)
                            }else {
                                CBToast.showToastAction(message: "Unsupported TIE Type")
                            }
                        }else {
                            CBToast.showToastAction(message: "Invalid TIE Type")
                        }
                    }
                }, failure:{ (errorMsg) in
                    CBToast.showToastAction(message: errorMsg! as NSString)
                    ATPKit.removeSpinner(spinner: sv)
                })
            }else {
//                print("Invalid Payload")
                errorDelegate?.errorHandle(source: "Payload", errorMsg: "Invalid Payload")
            }
        }else {
//            print("Invalid Payload")
            errorDelegate?.errorHandle(source: "Payload", errorMsg: "Invalid Payload")
        }
    }
    
    public func popoutTransaction(transactionInfo:BCITransactionInfo) {
//        print("Receive transaction request From SDRender")
        interactDelegate?.emitEvent(transactionInfo: transactionInfo)
    }
    
    @objc public func isRenderable(payload:String?) -> Bool {
       return bcinteractManager!.isRenderable(payload: payload)
    }
    
    @objc public func receiveSignedTransaction(signedTransaction:String) {
//        print("transaction delegate")
        transactionDelegate?.receiveTransaction(signedTransaction: signedTransaction)
    }
    
    
}
