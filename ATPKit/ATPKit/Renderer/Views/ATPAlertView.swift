//
//  ATPAlertView.swift
//  ATPKit
//
//  Created by yiren on 2018/11/9.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit

class ATPAlertView: ATPBaseView {
    public typealias ConfirmClosure = () -> ()
    public var confirmClosure:ConfirmClosure?
    //MARK:Variables
    lazy var backBlurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.isUserInteractionEnabled = true
        return blurView
    }()
    
    lazy var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 12.0
        return view
    }()
    
    lazy var logoImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/upToBlock.png", ofType: nil) {
            let image = UIImage.init(contentsOfFile: path)
            imageView.image = image
        }
        
        return imageView
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font =  UIFont.boldSystemFont(ofSize: 16*kWidthRate)
        label.textColor = kColorFromHex(rgbValue: 0x030303)
        label.text = Bundle.getATPLocalizedString(forkey: "你的信息即将上链", type: ATPKit.sharedInstance.lang)
        return label
    }()
    
    lazy var messageLabel:UILabel = {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: 13*kWidthRate)
        label.textColor = kColorFromHex(rgbValue: 0x030303)
        label.textAlignment = NSTextAlignment.center
        label.text = Bundle.getATPLocalizedString(forkey: "信息上链需缴纳少量矿工费，矿工费为奖励给矿工的费用，非ATP收取。", type: ATPKit.sharedInstance.lang)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var horiLine:UIView = {
        let view = UIView()
        view.backgroundColor = kColorFromHex(rgbValue: 0x3F3F3F).withAlphaComponent(0.1)
        return view
    }()
    
    lazy var vertiLine:UIView = {
        let view = UIView()
        view.backgroundColor = kColorFromHex(rgbValue: 0x3F3F3F).withAlphaComponent(0.1)
        return view
    }()
    
    lazy var cancelBtn:UIButton = {
       let btn = UIButton()
        btn.setTitle(Bundle.getATPLocalizedString(forkey: "取消", type: ATPKit.sharedInstance.lang), for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17*kWidthRate)
        btn.setTitleColor(kColorFromHex(rgbValue: 0x000000).withAlphaComponent(0.25), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(cancelAction), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    
    lazy var confirmBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle(Bundle.getATPLocalizedString(forkey: "继续", type: ATPKit.sharedInstance.lang), for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17*kWidthRate)
        btn.setTitleColor(.black, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(confirmAction), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    
    
    //MARK:Init
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .blue
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.isUserInteractionEnabled = true
        
        self.isHidden = true
        
        self.addSubview(self.backBlurView)
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.logoImageView)
        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.messageLabel)
        self.containerView.addSubview(self.cancelBtn)
        self.containerView.addSubview(self.confirmBtn)
        self.containerView.addSubview(self.horiLine)
        self.containerView.addSubview(self.vertiLine)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        self.backBlurView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.containerView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 300*kWidthRate, height: 235*kWidthRate))
        }
        self.logoImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 30*kWidthRate, height: 30*kWidthRate))
            make.centerX.equalTo(self)
            make.top.equalTo(self.containerView).offset(23*kWidthRate)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.logoImageView.snp.bottom).offset(14)
            make.centerX.equalTo(self.containerView)
        }
        self.messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(14)
            make.left.equalTo(self.containerView).offset(14*kWidthRate)
            make.right.equalTo(self.containerView).offset(-14*kWidthRate)
            make.centerX.equalTo(self.containerView)
        }
        self.cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.containerView)
            make.bottom.equalTo(self.containerView)
            make.height.equalTo(44*kWidthRate)
            make.right.equalTo(self.containerView.snp.centerX)
        }
        self.confirmBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.containerView)
            make.bottom.equalTo(self.containerView)
            make.height.equalTo(44*kWidthRate)
            make.left.equalTo(self.containerView.snp.centerX)
        }
        self.horiLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.containerView)
            make.height.equalTo(1)
            make.top.equalTo(self.cancelBtn)
        }
        self.vertiLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.containerView)
            make.height.equalTo(self.confirmBtn)
            make.bottom.equalTo(self.containerView)
            make.width.equalTo(1)
        }
    }
    
    @objc func cancelAction() {
        self.isHidden = true
    }
    
    @objc func confirmAction() {
        if let closure = self.confirmClosure {
            closure()
        }
    }
    
    public func setupInfo(title: String, message: String) {
        self.titleLabel.text = title
        self.messageLabel.text = message
    }
    
}
