//
//  ATPVotingRenderVC.swift
//  ATPKit
//
//  Created by yiren on 2018/11/19.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit

class ATPVotingRenderVC: UIViewController,ATPTransactionCallBack {
    
    var fromAddress:String?
    var contractAddress:String?
    var state:SDRenderState = SDRenderState.begin
    var transHash:String = ""
    var isAgree:Bool = false
    var isOnchian:Bool = false
    var isInteracted:Bool = false
    var counting:Int = 0
    var bciConfig:BCIConfig?
    var selectionText: String?
    
    
    lazy var naviView:ATPTopNaviView = {
        let view = ATPTopNaviView()
        weak var weakSelf = self
        view.myBackClosure = { [unowned self] () -> () in
            self.closeAction()
        }
        return view
    }()
    
    lazy var alertView:ATPAlertView = {
        let view = ATPAlertView()
        view.isHidden = true
        view.confirmClosure = { [unowned self] () -> () in
            self.submitAction()
        }
        return view
    }()
    
    lazy var displayView:VoteDisplayView = {
        let view = VoteDisplayView()
        view.isHidden = true
        view.mySelectionClosure = {[unowned self] (selection) -> () in
            self.isAgree = true
            self.selectionText = selection
        }
        
        return view
    }()
    
    lazy var receiptView:SDReceiptView = {
        let view = SDReceiptView()
        view.isHidden = true
        return view
    }()
    
    lazy var submitBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        btn.setTitle(Bundle.getATPLocalizedString(forkey: "submit", type: self.bciConfig?.language), for: UIControlState.normal)
        btn.backgroundColor = UIColor.black
        btn.setTitleColor(.white, for: UIControlState.normal)
        btn.layer.cornerRadius = 8*kWidthRate
        
        btn.center = CGPoint(x: self.view.center.x, y: self.view.bounds.height-50)
        btn.addTarget(self, action: #selector(showConfirmView), for: UIControlEvents.touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        let kit = ATPKit.sharedInstance.getBCinteractKit()
        kit?.transactionDelegate = self
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        self.naviView.titleLabel.text = self.getI18NString(key: "ATP链上互动")
        
        self.view.addSubview(self.submitBtn)
        self.view.addSubview(self.displayView)
        self.view.addSubview(self.receiptView)
        self.view.addSubview(self.naviView)
        self.view.addSubview(self.alertView)
        
        self.naviView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width:kScreenWidth, height: 94*kWidthRate))
            make.left.equalTo(self.view)
            make.top.equalTo(self.view)
        }
        self.displayView.snp.makeConstraints { (make) in
            make.top.equalTo(self.naviView.snp.bottom).offset(0)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.submitBtn.snp.top).offset(-20*kWidthRate)
        }
        self.receiptView.snp.makeConstraints { (make) in
            make.top.equalTo(self.naviView.snp.bottom).offset(0)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.submitBtn.snp.top).offset(-20*kWidthRate)
        }
        self.alertView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.submitBtn.snp.makeConstraints { (make) in
            if isIphoneX {
                make.bottom.equalTo(bottomLayoutGuide.snp.bottom).offset(-20*kWidthRate)
                
            }else {
                make.bottom.equalTo(self.view).offset(-12*kWidthRate)
            }
            make.left.equalTo(self.view).offset(18*kWidthRate)
            make.right.equalTo(self.view).offset(-18*kWidthRate)
            make.height.equalTo(48*kWidthRate)
        }
    }
    
    //MARK:ATP-Transaction-delegate
    func receiveTransaction(signedTransaction: String) {
//        print("signedTransac = \(signedTransaction)")
//        print("prepare to send")
        self.sendTransaction(signedTransaction: signedTransaction)
    }
    
    //MARK: TIE process
    public func setTIEData(tieModel:VoteTIEModel) {
        self.setupUI()
        if let address:String = self.fromAddress {
            print("当前地址:\(address)")
            self.displayView.topLabel.text = "\(getI18NString(key: "address"))\(address)"
        }
        if tieModel.question.count > 5 {
            
            self.receiptView.messageLabel.text = tieModel.message
            self.displayView.setTieModel(model: tieModel)
            self.changeRenderState(state: SDRenderState.begin)
            if tieModel.isInteracted == true {
                print("INTO INTERACTED STATE")
                self.isInteracted = true
                self.submitBtn.setTitle(getI18NString(key: "查看回执"), for: UIControlState.normal)
                self.displayView.optionContainerView.isUserInteractionEnabled = false
                self.displayView.optionContainerView.alpha = 0.5
            }
        }else {
            print("TIE NOT VALID")
        }
    }
    
    private func sendTransaction(signedTransaction:String) {
        
        self.changeRenderState(state: SDRenderState.checkState)
        let kit = ATPKit.sharedInstance.getBCinteractKit()
        
        kit?.sendRawTransaction(signedData: signedTransaction, completion: { (result) in
            
            let dict = result as! [String:Any]
            
            if let hash = dict["txhash"] as? String {
                print("txHashSended = \(hash)")
                print("tx hwole = \(dict)")
                self.receiptView.setHash(hash: hash)
                self.transHash = hash
                if let address:String = self.fromAddress {
                    self.receiptView.topLabel.text = "\(self.getI18NString(key: "address"))\(address)"
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
                    self.changeRenderState(state: SDRenderState.receipt)
                }
                //                self.getReceipt(txHash: hash)
            }else {
                print("No hash got")
            }
        }, failure: { (error) in
            CBToast.showToastAction(message: error! as NSString)
            
        })
    }
    
    @objc private func checkReceipt() {
//        print("IN CHECKING!!!!!!!!!!!")
        let sv = ATPSmartDropRender.displaySpinner(onView: self.view)
        let kit = ATPKit.sharedInstance.getBCinteractKit()
        if let address = fromAddress {
            kit?.checkReceipt(fromAddress: address, completion: { (result) in
                ATPSmartDropRender.removeSpinner(spinner: sv)
                let dict = result as! [String:Any]
                if let hash = dict["interactTxHash"] as? String {
                    self.receiptView.setHash(hash: hash)
                    if let address = self.fromAddress {
                        self.receiptView.topLabel.text = "\(self.getI18NString(key: "address"))\(address)"
                    }
                    self.changeRenderState(state: .receipt)
                }
                print("CHECKING RESULT = \(result)")
            }, failure: { (errorMsg) in
                ATPSmartDropRender.removeSpinner(spinner: sv)
                CBToast.showToastAction(message: errorMsg! as NSString)
            })
        }
    }
    
    //MARK: private func
    func changeRenderState(state:SDRenderState) {
        self.state = state
        switch self.state {
        case .begin:
            self.displayView.isHidden = false
            self.submitBtn.isEnabled = true
        case .checkState:
            print("gif state should loading")
            self.isOnchian = false
            self.displayView.isHidden = false
            self.startCounting()
            self.submitBtn.isEnabled = false
        //            self.loadingView.show()
        case .receipt:
            self.isOnchian = true
            self.displayView.isHidden = true
            self.counting = 0
            self.receiptView.isHidden = false
            self.submitBtn.isEnabled = true
            self.submitBtn.setTitle(getI18NString(key: "完成"), for: UIControlState.normal)
        case .transFail:
            //NOT IN USE
            self.displayView.isHidden = true
            
        }
    }
    
    @objc func submitAction() {
        self.alertView.isHidden = true
        let kit = ATPKit.sharedInstance.getBCinteractKit()
        let tranInfo = BCITransactionInfo()
        if let conAddr = contractAddress {
            //            tranInfo.setupData(contractAddress: conAddr, functionName: "interact", args: ["1"])
            if let fromAddr = fromAddress {
                if self.selectionText != nil {
                    print("selectedText = \(self.selectionText)")
                    tranInfo.setupData(contractAddress: conAddr, functionName: "interact", fromAddress: fromAddr, args: [self.selectionText!])
                    kit?.popoutTransaction(transactionInfo: tranInfo)
                }else {
                    CBToast.showToastAction(message: "option text error")
                }
                
            }
        }else {
            print("contractAddress: nil")
        }
    }
    
    @objc func showConfirmView() {
        print("state = \(self.state.rawValue);interacted = \(isInteracted)")
        if self.state == SDRenderState.receipt {
            self.closeAction()
        }else {
            if isInteracted {
                self.checkReceipt()
            }else {
                if isAgree {
                    self.alertView.isHidden = false
                }else {
                    CBToast.showToastAction(message: getI18NString(key: "请完成选项再提交") as NSString)
                }
            }
            
        }
    }
    
    @objc func closeAction() {
        let window = UIApplication.shared.keyWindow!
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.isRemovedOnCompletion = true
        window.layer.add(transition, forKey: "transitioninout")
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func startCounting() {
        if isOnchian == false {
            self.submitBtn.setTitle("\(getI18NString(key: "上链中"))(\(counting)s)...", for: UIControlState.normal)
            self.counting += 1
            self.perform(#selector(startCounting), with: nil, afterDelay: 1.0)
        }
    }
    
    public func setConfig(config:BCIConfig?) {
        self.bciConfig = config
    }
    
    private func getI18NString(key:String) -> String {
        return Bundle.getATPLocalizedString(forkey: key, type: self.bciConfig?.language)
    }
}
