//
//  ATPTopNaviView.swift
//  ATPKit
//
//  Created by yiren on 2018/11/7.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit
import SnapKit

public class ATPTopNaviView: UIView {
    
    public typealias BackClosure = () -> ()
    public var myBackClosure:BackClosure?
    
    lazy public var titleLabel:UILabel = {
        let label = UILabel()
        label.text = Bundle.getATPLocalizedString(forkey: "ATP链上互动", type: ATPKit.sharedInstance.lang)
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18*kWidthRate)
        label.sizeToFit()
        
        return label
    }()
    
    lazy var backBtn:UIButton = {
        let btn = UIButton()
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/backbtn.png", ofType: nil) {
            let image = UIImage.init(contentsOfFile: path)
            btn.setImage(image, for: UIControl.State.normal)
            btn.imageEdgeInsets = UIEdgeInsets(top: 9, left: 10, bottom: 9, right: 10)
        }
        btn.addTarget(self, action: #selector(backAction), for: UIControl.Event.touchUpInside)
        
        return btn
    }()
    
    lazy public var logoImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/atptitlelogo.png", ofType: nil) {
            let image = UIImage.init(contentsOfFile: path)
            imageView.image = image
        }
        return imageView
    }()
    
    lazy var horiLine:UIView = {
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
        self.addSubview(self.titleLabel)
        self.addSubview(self.backBtn)
        self.addSubview(self.logoImageView)
        self.addSubview(self.horiLine)
        //
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.logoImageView.snp.top).offset(-6*kWidthRate)
        }
        self.backBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-18*kWidthRate)
            make.size.equalTo(CGSize(width: 38*kWidthRate, height: 38*kWidthRate))
            make.left.equalTo(self).offset(3)
        }
        self.horiLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.height.equalTo(1)
            make.left.right.equalTo(self)
        }
        self.logoImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-10*kWidthRate)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 82*kWidthRate, height: 14*kWidthRate))
        }
    }
    
    @objc func backAction() {
        if let block = self.myBackClosure {
            block()
        }
    }
    
}
