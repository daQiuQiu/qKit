//
//  SDCheckBoxView.swift
//  ATPKit
//
//  Created by yiren on 2018/11/20.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit

class SDCheckBoxView: UIView {
    
    public lazy var imageView:UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        
        return imageview
    }()
    
    public lazy var label:UILabel = {
        let textlabel = UILabel()
        textlabel.font = UIFont.systemFont(ofSize: 14*kWidthRate)
        textlabel.textColor = kColorFromHex(rgbValue: 0x000000)
        textlabel.numberOfLines = 0
        
        return textlabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
        setupUI()
    }
    
    func setupUI() {
        self.addSubview(imageView)
        self.addSubview(label)
        
        self.imageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10*kWidthRate)
            make.top.equalTo(self)
            make.size.equalTo(CGSize(width: 20*kWidthRate, height: 20*kWidthRate))
        }
        self.label.snp.makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp.right).offset(8*kWidthRate)
            make.centerY.equalTo(self.imageView)
            make.right.equalTo(self)
        }
    }

}
