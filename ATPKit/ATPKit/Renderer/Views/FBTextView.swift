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
        tf.layer.borderColor = UIColor.darkGray.cgColor
        return tf;
    }()
    
    public lazy var deleteBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("删除", for: UIControl.State.normal)
        btn.setTitleColor(.black, for: UIControlState.normal)
        
        
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
        
        self.textfield.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10*kWidthRate)
            make.top.equalTo(self).offset(10*kWidthRate)
            make.bottom.equalTo(self).offset(-10*kWidthRate)
            make.right.equalTo(self.deleteBtn.snp.left).offset(-10*kWidthRate)
        }
        self.deleteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10*kWidthRate)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 50*kWidthRate, height: 40*kWidthRate))
        }
    }
    
    
}
