//
//  SDGifView.swift
//  ATPKit
//
//  Created by yiren on 2018/11/8.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit

class SDGifView: UIView {
    
    lazy var imageView: UIImageView = {
        let imagev = UIImageView()
        
        imagev.contentMode = UIViewContentMode.scaleAspectFit
        return imagev
    }()
    
    lazy var backBlurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.isUserInteractionEnabled = true
//        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return blurView
    }()
    
    lazy var logoImageView: UIImageView = {
        let imagev = UIImageView()
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/atplogo.png", ofType: nil) {
            let image = UIImage.init(contentsOfFile: path)
            imagev.image = image
        }
        
        imagev.contentMode = UIViewContentMode.scaleAspectFit
        return imagev
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        
        
        self.addSubview(self.backBlurView)
        self.addSubview(self.imageView)
        self.addSubview(self.logoImageView)
        
        setupGIF()
        self.backBlurView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.logoImageView.snp.bottom).offset(63*kWidthRate)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 200*kWidthRate, height: 22*kWidthRate))
        }
        
        self.logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(140*kWidthRate)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 91*kWidthRate, height: 98*kWidthRate))
        }
    }
    
    func setupGIF() {
        guard let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/onChain.gif", ofType: nil) else {
            
            return }
        guard let data = NSData(contentsOfFile: path) else {
            
            return
        }
        
        // 从data中读取数据: 将data转成CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else {
            
            return }
        let imageCount = CGImageSourceGetCount(imageSource)
        
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0..<imageCount {
            // .取出图片
            
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            if i == 0 {
                imageView.image = image
            }
            images.append(image)
            
            // 取出持续的时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) else { continue }
            guard let gifDict = (properties as NSDictionary)[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
            
        }
        
        imageView.animationImages = images
        imageView.animationDuration = totalDuration
        imageView.animationRepeatCount = 0

//        imageView.startAnimating()
    
    }
    
    public func show() {
        imageView.startAnimating()
        self.isHidden = false
    }
    
    public func hide() {
        imageView.stopAnimating()
        self.isHidden = true
    }
}
