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
        tf.layer.borderColor = UIColor.gray.cgColor
        return tf;
    }()
    
    lazy var deleteBtn:UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(deleteAction), for: UIControlEvents.touchUpInside)
        
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
            make.left.equalTo(self).offset(20*kWidthRate)
            make.top.bottom.equalTo(self)
            make.right.equalTo(self.deleteBtn.snp.left).offset(-10*kWidthRate)
        }
        self.deleteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20*kWidthRate)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 30*kWidthRate, height: 30*kWidthRate))
        }
    }
    
    @objc func deleteAction() {
        self.removeFromSuperview()
    }
}
