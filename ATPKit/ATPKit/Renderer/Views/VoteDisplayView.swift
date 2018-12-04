//
//  VoteDisplayView.swift
//  ATPKit
//
//  Created by yiren on 2018/11/19.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit
import DLRadioButton
import SDWebImage

class VoteDisplayView: UIView {
    
    public typealias SelectionClosure = (String) -> ()
    public var mySelectionClosure:SelectionClosure?
    
    fileprivate var headOptionBtn: DLRadioButton?
    fileprivate var options:[String]?
    fileprivate var selectedIndex: Int = 0
    fileprivate var selectedOption: String = ""
    
    public lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .white
        scroll.showsHorizontalScrollIndicator = false
        scroll.contentSize = CGSize(width: kScreenWidth, height: 700*kHeightRate)
        if #available(iOS 11.0, *) {
            scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never;
        }else {
            
        }
        return scroll
    }()

    public lazy var imageView: UIImageView = {
        let imagev = UIImageView()
        imagev.isUserInteractionEnabled = true
        imagev.contentMode = UIViewContentMode.scaleAspectFit
        imagev.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 380*kWidthRate)
//        imagev.sizeToFit()
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/placeholder.png", ofType: nil) {
            let image = UIImage.init(contentsOfFile: path)!
            imagev.image = image
        }else {
            print("no path!!!")
        }
//        imagev.isHidden = true
        return imagev
    }()
    
    public lazy var topLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = kColorFromHex(rgbValue: 0x7A7A7A)
        label.font = UIFont.systemFont(ofSize: 10*kWidthRate)
        label.textAlignment = NSTextAlignment.center
        label.layer.shadowOffset = CGSize(width: 0, height: 3)
        label.layer.shadowOpacity = 0.1
        label.layer.shadowRadius = 10
        label.layer.shadowColor = UIColor.black.cgColor
        
        return label
    }()
    
    public lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = kColorFromHex(rgbValue: 0x202020)
        label.font = UIFont.systemFont(ofSize: 20*kWidthRate)
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    
    public lazy var optionContainerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    lazy var horiLine:UIView = {
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
        
        self.addSubview(self.scrollView)
        self.addSubview(self.topLabel)
        self.addSubview(self.horiLine)
        scrollView.addSubview(self.imageView)
        scrollView.addSubview(self.questionLabel)
        scrollView.addSubview(self.optionContainerView)
        self.addSubview(self.bottomHoriLine)
        
        self.topLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(30*kWidthRate)
        }
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.topLabel.snp.bottom)
            make.bottom.equalTo(self)
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
//        self.imageView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.scrollView)
//            make.left.equalTo(self)
//            make.width.equalTo(kScreenWidth)
//            make.height.equalTo(380*kHeightRate)
//        }
    }
    //set tie UI components
    func setTieModel(model:VoteTIEModel) {
        if model.creatives.count > 0 {
            self.setPostImage(url: model.creatives[0])
            self.questionLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(self.imageView.snp.bottom).offset(30*kWidthRate)
                make.left.equalTo(self).offset(60*kWidthRate)
                make.right.equalTo(self).offset(-60*kWidthRate)
            }
            
        }else {
            
            self.scrollView.contentSize = CGSize(width: kScreenWidth, height: 400*kHeightRate)
            self.questionLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(self.horiLine.snp.bottom).offset(30*kWidthRate)
                make.left.equalTo(self).offset(60*kWidthRate)
                make.right.equalTo(self).offset(-60*kWidthRate)
            }
        }
        self.questionLabel.text = model.question
        self.optionContainerView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.questionLabel)
            make.right.equalTo(self.questionLabel)
            make.top.equalTo(self.questionLabel.snp.bottom).offset(30*kWidthRate)
            make.height.equalTo(300*kWidthRate)
        }
        
        if model.optionsText.count > 1 {
            self.options = model.options
            headOptionBtn = self.createRadioButton(frame: CGRect(x: 0, y: 0, width: 255*kWidthRate, height: 20*kWidthRate), title: model.optionsText[0], color: ATPSetColor(R: 45, G: 123, B: 246, A: 1.0))
            self.optionContainerView.addSubview(headOptionBtn!)
            headOptionBtn?.tag = 0
        }
        
        var otherButtons: [DLRadioButton] = []
        for index in 1..<model.optionsText.count {
            let y:CGFloat = CGFloat(index*45)*kWidthRate
            let btn = self.createRadioButton(frame: CGRect(x: 0.0, y: y, width: 255*kWidthRate, height: 20*kWidthRate), title: model.optionsText[index], color: ATPSetColor(R: 45, G: 123, B: 246, A: 1.0))
            btn.tag = index
            self.optionContainerView.addSubview(btn)
            otherButtons.append(btn)
            
        }
        headOptionBtn?.otherButtons = otherButtons
    }
    
    public func setPostImage(url: String) {
        
//        self.imageView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 380*kScreenWidth)
        var plimage:UIImage?
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/placeholder.png", ofType: nil) {
            let image = UIImage.init(contentsOfFile: path)!
            plimage = image
        }
        
        self.imageView.sd_setImage(with: URL(string: url), placeholderImage: plimage) { [unowned self] (image, error, _, _) in
            if let dImage = image {
                self.changeConstraints(height: kScreenWidth*(dImage.size.height/dImage.size.width))
            }
            if error != nil {
                if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/placeholderFail.png", ofType: nil) {
                    let image = UIImage.init(contentsOfFile: path)!
                    self.imageView.image = image
                }
            }
        }
        
    }
    
    func changeConstraints(height:CGFloat) {
        
        self.scrollView.contentSize = CGSize(width: kScreenWidth, height: height+360)
        self.imageView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
        
    }
    
    private func createRadioButton(frame: CGRect, title: String, color: UIColor) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame)
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 15*kWidthRate)
        radioButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        radioButton.titleLabel?.numberOfLines = 0
        radioButton.setTitle(title, for: [])
        radioButton.setTitleColor(.black, for: [])
        radioButton.iconColor = ATPSetColor(R: 159, G: 159, B: 159, A: 1.0)
        radioButton.indicatorColor = color
        radioButton.iconSize = 22*kWidthRate
        radioButton.iconStrokeWidth = 1
//        radioButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20*kWidthRate, 0, -20*kWidthRate)
//        radioButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20*kWidthRate, 0, 20*kWidthRate)
        
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        radioButton.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/singleBoxUnSelected.png", ofType: nil) {
//            let image = UIImage.init(contentsOfFile: path)!
//            radioButton.icon = image
//        }
//        if let path1 = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/singleBoxSelected.png", ofType: nil) {
//            let image = UIImage.init(contentsOfFile: path1)!
//            radioButton.iconSelected = image
//        }
        radioButton.addTarget(self, action: #selector(chooseAction(sender:)), for: UIControlEvents.touchUpInside)
        radioButton.isMultipleSelectionEnabled = false
        radioButton.isMultipleTouchEnabled = false
        
        
        return radioButton
    }
    
    @objc func chooseAction(sender: DLRadioButton) {
        let btn = sender
        btn.iconColor = ATPSetColor(R: 45, G: 123, B: 246, A: 1.0)
        if headOptionBtn?.tag != btn.tag {
            headOptionBtn?.iconColor = ATPSetColor(R: 159, G: 159, B: 159, A: 1.0)
        }
        if let headBtn = headOptionBtn {
            if headBtn.otherButtons.count > 1 {
                for index in 0..<headBtn.otherButtons.count {
                    
                    let otherbtn = headBtn.otherButtons[index]
                    if otherbtn.tag != btn.tag {
                        otherbtn.iconColor = ATPSetColor(R: 159, G: 159, B: 159, A: 1.0)
                    }
                }
            }
        }
        if let closure = mySelectionClosure {
            if self.options != nil {
                closure(self.options![btn.tag])
            }else {
                
            }
        }
    }
}
