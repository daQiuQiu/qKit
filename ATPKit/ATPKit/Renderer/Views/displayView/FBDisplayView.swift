//
//  FBDisplayView.swift
//  ATPKit
//
//  Created by yiren on 2019/1/2.
//  Copyright © 2019 Atlas Protocol. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class FBDisplayView: UIView,UITableViewDelegate,UITableViewDataSource{
    
    public typealias CheckClosure = (Bool) -> ()
    public var myCheckClosure:CheckClosure?
    var isSelected:Bool = false
    var tfCount:Int = 0
    var imageCellHeight:Float = 0
    var displayArray:Array = [1]
    
    public lazy var tableView: UITableView = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: UITableViewStyle.plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 0
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "displaycell")
//        _tableview.estimatedRowHeight = 0;
//        _tableview.estimatedSectionHeaderHeight = 0;
//        _tableview.estimatedSectionFooterHeight = 0;
//        _tableview.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0);
        
        return tableview
    }()
    
    public lazy var imageView: UIImageView = {
        let imagev = UIImageView()
        imagev.isUserInteractionEnabled = true
        imagev.contentMode = UIViewContentMode.scaleAspectFit
        imagev.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 380*kHeightRate)
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/placeholder.png", ofType: nil) {
            let image = UIImage.init(contentsOfFile: path)!
            imagev.image = image
        }else {
            //            print("no path!!!")
        }
        return imagev
    }()
    
    public lazy var addTFBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("新增", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(addTFAction), for: UIControlEvents.touchUpInside)
        btn.layer.cornerRadius = 20
    
        return btn
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
    
    public lazy var tfTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = kColorFromHex(rgbValue: 0x7A7A7A)
        label.font = UIFont.systemFont(ofSize: 10*kWidthRate)
        label.text = "请填写地址"
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
        self.addSubview(self.tableView)
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
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.topLabel.snp.bottom)
            make.bottom.equalTo(self)
        }
    }
    
    @objc func addTFAction() {
        //计数+1
        tfCount = tfCount + 1
        let tfView = FBTextView()
        tfView.isUserInteractionEnabled = true
        tfView.tag = tfCount
        
    }
    
    public func setPostImage(url: String) {
        var plimage:UIImage?
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/placeholder.png", ofType: nil) {
            let image = UIImage.init(contentsOfFile: path)!
            plimage = image
        }
        
        self.imageView.sd_setImage(with: URL(string: url), placeholderImage: plimage) { [unowned self] (image, error, _, _) in
            if let dImage = image {
                imageCellHeight = 
            }
            if error != nil {
                if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/placeholderFail.png", ofType: nil) {
                    let image = UIImage.init(contentsOfFile: path)!
                    self.imageView.image = image
                }
            }
        }
    }
    
    //MARK:tableview datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayArray.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200*kWidthRate
        }else {
            return 50*kWidthRate
        }
    }
    
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
            return cell
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

