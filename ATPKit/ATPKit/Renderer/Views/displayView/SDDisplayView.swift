//
//  SDDisplayView.swift
//  ATPKit
//
//  Created by yiren on 2018/11/8.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit
import DLRadioButton
//import SDWebImage

class SDDisplayView: UIView {
    public typealias CheckClosure = (Bool) -> ()
    public var myCheckClosure:CheckClosure?
    var isSelected:Bool = false
    
    public lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .white
        scroll.showsHorizontalScrollIndicator = false
        scroll.contentSize = CGSize(width: kScreenWidth, height: 400*kHeightRate)
        if #available(iOS 11.0, *) {
            scroll.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        }
        return scroll
    }()
    
    public lazy var imageView: UIImageView = {
        let imagev = UIImageView()
        imagev.isUserInteractionEnabled = true
        imagev.contentMode = UIView.ContentMode.scaleAspectFit
        imagev.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 380*kHeightRate)
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/placeholder.png", ofType: nil) {
            let image = UIImage.init(contentsOfFile: path)!
            imagev.image = image
        }else {
//            print("no path!!!")
        }
        return imagev
    }()
    
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
    
    lazy var horiLine:UIView = {
        let view = UIView()
        view.backgroundColor = kColorFromHex(rgbValue: 0x3F3F3F).withAlphaComponent(0.1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 3
        return view
    }()
    
    lazy var bottomHoriLine:UIView = {
        let view = UIView()
        view.backgroundColor = kColorFromHex(rgbValue: 0x3F3F3F).withAlphaComponent(0.1)
        return view
    }()
    
    lazy var checkBoxView: SDCheckBoxView = {
        let view = SDCheckBoxView()
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(checkAction))
        view.addGestureRecognizer(tap)
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
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
        self.scrollView.addSubview(self.checkBoxView)
        self.addSubview(self.bottomHoriLine)
        self.addSubview(self.topLabel)
        self.addSubview(self.horiLine)
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
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.topLabel.snp.bottom)
            make.bottom.equalTo(self)
        }
        
//        self.imageView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.scrollView)
//            make.left.equalTo(self)
//            make.width.equalTo(kScreenWidth)
//            make.bottom.equalTo(self).offset(-60*kWidthRate)
//        }
        self.checkBoxView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.imageView.snp.bottom).offset(20*kWidthRate)
            make.size.equalTo(CGSize(width: 200*kWidthRate, height: 20*kWidthRate))
        }
    }
    
    @objc func checkAction() {
        self.isSelected = !self.isSelected
        if isSelected {
            if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/checkboxSelected.png", ofType: nil) {
                let image = UIImage.init(contentsOfFile: path)!
                self.checkBoxView.imageView.image = image
            }
        }else {
            if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/checkboxUnSelected.png", ofType: nil) {
                let image = UIImage.init(contentsOfFile: path)!
                self.checkBoxView.imageView.image = image
            }
        }
        if let closure = self.myCheckClosure {
            closure(self.isSelected)
        }
    }
    
    public func setCheckBoxText(text: String) {
        self.checkBoxView.label.text = text
        if isSelected {
            if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/checkboxSelected.png", ofType: nil) {
                let image = UIImage.init(contentsOfFile: path)!
                self.checkBoxView.imageView.image = image
            }
        }else {
            if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/checkboxUnSelected.png", ofType: nil) {
                let image = UIImage.init(contentsOfFile: path)!
                self.checkBoxView.imageView.image = image
            }
        }
        
        let rect = self.sizeWithText(text: text, font: UIFont.systemFont(ofSize: 14*kWidthRate), size: CGSize(width: kScreenWidth, height: 20*kWidthRate))
        self.checkBoxView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.imageView.snp.bottom).offset(20*kWidthRate)
            make.centerX.equalTo(self)
            
            if rect.size.width+60 < kScreenWidth - 30 {
                make.size.equalTo(CGSize(width: (rect.size.width+60*kWidthRate), height: 20*kWidthRate))
            }else {
                make.size.equalTo(CGSize(width: (kScreenWidth - 40)*kWidthRate, height: 20*kWidthRate))
            }
            
        }
    }
    
    public func setPostImage(url: String) {
        var plimage:UIImage?
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/placeholder.png", ofType: nil) {
            let image = UIImage.init(contentsOfFile: path)!
            plimage = image
        }
        
        self.imageView.sd_setImage(with: URL(string: url), placeholderImage: plimage) { [unowned self] (image, error, _, _) in
            if let dImage = image {
                self.scrollView.contentSize = CGSize(width: kScreenWidth, height: kScreenWidth*(dImage.size.height/dImage.size.width)+60*kWidthRate)
                self.imageView.snp.remakeConstraints({ (make) in
                    make.top.equalTo(self.scrollView)
                    make.left.equalTo(self)
                    make.size.equalTo(CGSize(width: kScreenWidth, height: kScreenWidth*(dImage.size.height/dImage.size.width)))
                })
            }
            if error != nil {
                if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/placeholderFail.png", ofType: nil) {
                    let image = UIImage.init(contentsOfFile: path)!
                    self.imageView.image = image
                }
            }
        }
    }
    
    private func sizeWithText(text: String, font: UIFont, size: CGSize) -> CGRect {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
//        print("checkboxtextsize = \(rect.size.width)")
        return rect;
    }
}
