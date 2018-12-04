//
//  SDReceiptView.swift
//  ATPKit
//
//  Created by yiren on 2018/11/8.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit

class SDReceiptView: UIView {
    
    private var urlLink:String = ""
    
    public lazy var topLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = kColorFromHex(rgbValue: 0x7A7A7A)
        label.font = UIFont.systemFont(ofSize: 10*kWidthRate)
        label.textAlignment = NSTextAlignment.center
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowOpacity = 0.1
        label.layer.shadowRadius = 10
        label.layer.shadowColor = UIColor.black.cgColor
        
        return label
    }()
    
    public lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = kColorFromHex(rgbValue: 0x000000)
        label.text = "感谢您参与本次空投！您的空投将会在72小时内发放"
        label.font = UIFont.systemFont(ofSize: 17*kWidthRate)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    
    public lazy var iconImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = UIViewContentMode.scaleAspectFit
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/success.png", ofType: nil) {
            let image = UIImage.init(contentsOfFile: path)
            imageV.image = image
        }
        return imageV
    }()
    
    public lazy var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.isUserInteractionEnabled = true
        return view
    }()
    
    public lazy var containerTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = kColorFromHex(rgbValue: 0x8F8F8F)
        label.font = UIFont.systemFont(ofSize: 15*kWidthRate)
        label.text = Bundle.getATPLocalizedString(forkey: "你的信息已经上链", type: ATPKit.sharedInstance.lang)
        label.sizeToFit()
        
        return label
    }()
    
    public lazy var containerIcon:UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = UIViewContentMode.scaleAspectFit
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/done.png", ofType: nil) {
            let image = UIImage.init(contentsOfFile: path)
            imageV.image = image
        }
        imageV.alpha = 0.5
        return imageV
    }()
    
    public lazy var QRImageView:UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = UIViewContentMode.scaleAspectFit
        
        return imageV
    }()
    
    public lazy var hashNameTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = Bundle.getATPLocalizedString(forkey: "交易哈希", type: ATPKit.sharedInstance.lang)
        label.textColor = kColorFromHex(rgbValue: 0x000000)
        label.font = UIFont.systemFont(ofSize: 15*kWidthRate)
        label.sizeToFit()
        
        return label
    }()
    
    public lazy var hashLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = kColorFromHex(rgbValue: 0x8F8F8F)
        label.font = UIFont.systemFont(ofSize: 15*kWidthRate)
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    
    public lazy var copyHashBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle(Bundle.getATPLocalizedString(forkey: "复制交易哈希", type: ATPKit.sharedInstance.lang), for: UIControlState.normal)
        if kScreenWidth < 375 {
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        }
        btn.addTarget(self, action: #selector(copyHashAction), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    
    public lazy var copyLinkBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle(Bundle.getATPLocalizedString(forkey: "复制浏览器链接", type: ATPKit.sharedInstance.lang), for: UIControlState.normal)
        if kScreenWidth < 375 {
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        }
        btn.addTarget(self, action: #selector(copyLinkAction), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    
    lazy var horiLine:UIView = {
        let view = UIView()
        view.backgroundColor = kColorFromHex(rgbValue: 0x3F3F3F).withAlphaComponent(0.1)
        return view
    }()
    
    lazy var containerLine:UIView = {
        let view = UIView()
        view.backgroundColor = kColorFromHex(rgbValue: 0x3F3F3F).withAlphaComponent(0.1)
        return view
    }()
    
    lazy var bottomHoriLine:UIView = {
        let view = UIView()
        view.backgroundColor = kColorFromHex(rgbValue: 0x3F3F3F).withAlphaComponent(0.1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    
    func setupUI() {
        self.isUserInteractionEnabled = true
        
        self.addSubview(self.topLabel)
        self.addSubview(self.horiLine)
        self.addSubview(self.iconImageView)
        self.addSubview(self.messageLabel)
        self.addSubview(self.bottomHoriLine)
        self.addSubview(self.containerView)
        //container
//        self.containerView.addSubview(self.containerIcon)
        self.containerView.addSubview(self.containerTitle)
        self.containerView.addSubview(self.hashNameTitle)
        self.containerView.addSubview(self.hashLabel)
        self.containerView.addSubview(self.containerLine)
        self.containerView.addSubview(self.QRImageView)
        self.containerView.addSubview(self.copyHashBtn)
        self.containerView.addSubview(self.copyLinkBtn)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        self.topLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(30*kWidthRate)
        }
        self.horiLine.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(self.topLabel)
            make.height.equalTo(1)
        }
        self.bottomHoriLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.right.equalTo(self)
            make.height.equalTo(1)
        }
        self.iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLabel.snp.bottom).offset(50*kWidthRate)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 50*kWidthRate, height: 50*kWidthRate))
        }
        self.messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(42*kWidthRate)
            make.right.equalTo(self).offset(-42*kWidthRate)
            make.top.equalTo(self.iconImageView.snp.bottom).offset(18*kWidthRate)
        }
        self.containerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-36*kWidthRate)
            make.left.equalTo(self).offset(18*kWidthRate)
            make.right.equalTo(self).offset(-18*kWidthRate)
            make.height.equalTo(210*kWidthRate)
        }
//        self.containerIcon.snp.makeConstraints { (make) in
//            make.size.equalTo(CGSize(width: 18*kWidthRate, height: 18*kWidthRate))
//            make.left.equalTo(self.containerView).offset(18*kWidthRate)
//            make.top.equalTo(self.containerView).offset(20*kWidthRate)
//        }
        self.containerTitle.snp.makeConstraints { (make) in
            make.left.equalTo(self.containerView).offset(18*kWidthRate)
            make.top.equalTo(self.containerView).offset(20*kWidthRate)
        }
        self.containerLine.snp.makeConstraints { (make) in
            make.left.equalTo(self.containerView).offset(18*kWidthRate)
            make.right.equalTo(self.containerView).offset(-18*kWidthRate)
            make.top.equalTo(self.containerView).offset(60*kWidthRate)
            make.height.equalTo(1)
        }
        self.hashNameTitle.snp.makeConstraints { (make) in
            make.left.equalTo(self.containerView).offset(18*kWidthRate)
            make.top.equalTo(self.containerLine.snp.bottom).offset(16*kWidthRate)
        }
        self.hashLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.hashNameTitle)
            make.top.equalTo(self.hashNameTitle.snp.bottom).offset(6*kWidthRate)
            make.width.equalTo(190*kWidthRate)
        }
        self.QRImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 80*kWidthRate, height: 80*kWidthRate))
            make.top.equalTo(self.hashNameTitle)
            make.right.equalTo(self.containerView).offset(-24*kWidthRate)
        }
        self.copyHashBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.hashLabel)
            make.bottom.equalTo(self.containerView).offset(-16*kWidthRate)
        }
        self.copyLinkBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(copyHashBtn)
            
            make.right.equalTo(self.QRImageView)
        }
    }
    
    @objc func copyLinkAction() {
        
        if let hash = hashLabel.text {
            if ATPKit.sharedInstance.isDebug {
                UIPasteboard.general.string = String(format: "%@%@", ATPConstants.explorerTest,hash)
            }else {
                UIPasteboard.general.string = String(format: "%@%@", ATPConstants.explorerMain,hash)
            }
            
            CBToast.showToastAction(message: Bundle.getATPLocalizedString(forkey: "复制成功", type: ATPKit.sharedInstance.lang) as NSString)
        }
    }
    
    @objc func copyHashAction() {
        
        if let hash = hashLabel.text {
            UIPasteboard.general.string = hash
            CBToast.showToastAction(message: Bundle.getATPLocalizedString(forkey: "复制成功", type: ATPKit.sharedInstance.lang) as NSString)
        }
    }
    
    public func setHash(hash: String) {
        self.hashLabel.text = hash
        if ATPKit.sharedInstance.isDebug {
            self.urlLink = String(format: "%@%@", ATPConstants.explorerTest,hash)
        }else {
            self.urlLink = String(format: "%@%@", ATPConstants.mainnet,hash)
        }
        self.urlLink = String(format: "%@%@", ATPConstants.explorerTest,hash)
        self.QRImageView.image = setupQRCodeImage(self.urlLink)
    }
    
    //MARK: -传进去字符串,生成二维码图片
    func setupQRCodeImage(_ text: String) -> UIImage {
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        //将url加入二维码
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        //取出生成的二维码（不清晰）
        if let outputImage = filter?.outputImage {
            //生成清晰度更好的二维码
//            let qrCodeImage = setupHighDefinitionUIImage(outputImage, size: 300)
            
            return UIImage(ciImage: outputImage)
        }
        
        return UIImage()
    }
}
