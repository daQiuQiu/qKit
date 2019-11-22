//
//  FBTextView.swift
//  ATPKit
//
//  Created by yiren on 2019/1/4.
//  Copyright © 2019 Atlas Protocol. All rights reserved.
//

import UIKit

class FBTextView: UIView {
    
    lazy var textfield:UITextField = {
        let tf = UITextField()
        tf.layer.borderWidth = 1.0
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        tf.leftViewMode = UITextField.ViewMode.always
        tf.layer.cornerRadius = 6*kWidthRate
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        return tf;
    }()
    
    public lazy var deleteBtn:UIButton = {
        let btn = UIButton()
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/delete.png", ofType: nil) {
            let image = UIImage.init(contentsOfFile: path)
            btn.setImage(image, for: UIControl.State.normal)
        }
        btn.setTitleColor(.black, for: UIControl.State.normal)
        
        
        return btn
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
        self.addSubview(textfield)
        self.addSubview(deleteBtn)
        
    }
    
    public func hideDeleteBtn() {
        self.deleteBtn.isHidden = true
        self.textfield.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10*kWidthRate)
            make.top.equalTo(self).offset(10*kWidthRate)
            make.bottom.equalTo(self).offset(-10*kWidthRate)
            make.right.equalTo(self).offset(-40*kWidthRate)
        }
    }
    
    public func showDeleteBtn() {
        self.deleteBtn.isHidden = false
        self.textfield.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10*kWidthRate)
            make.top.equalTo(self).offset(10*kWidthRate)
            make.bottom.equalTo(self).offset(-10*kWidthRate)
            make.right.equalTo(self.deleteBtn.snp.left).offset(-10*kWidthRate)
        }
        self.deleteBtn.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-10*kWidthRate)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 20*kWidthRate, height: 20*kWidthRate))
        }
    }
}
