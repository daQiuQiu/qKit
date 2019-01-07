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
    var imageCellHeight:CGFloat = 0
    var maxTag:Int = 1
    public var displayArray:Array = [1]
    var creativeURL:String = ""
    var placeholder:String = ""
    var titletext:String = ""
    
    public var indexArray = [IndexPath]()
    
    public lazy var tableView: UITableView = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: UITableViewStyle.plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 0
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableview.register(ImageTableViewCell.self, forCellReuseIdentifier: "imagecell")
        tableview.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "tfcell")
        tableview.estimatedRowHeight = 0;
        tableview.estimatedSectionHeaderHeight = 0;
//        _tableview.estimatedSectionFooterHeight = 0;
        tableview.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0);
        tableview.showsVerticalScrollIndicator = true
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 55*kWidthRate))
        
        view.isUserInteractionEnabled = true
        view.addSubview(self.addTFBtn)
        self.addTFBtn.snp.makeConstraints{(make) in
            make.center.equalTo(view)
            make.size.equalTo(CGSize(width: 90*kWidthRate, height: 35*kWidthRate))
        }
        tableview.tableFooterView = view
        
        return tableview
    }()
    
    
    
    public lazy var addTFBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = kColorFromHex(rgbValue: 0x007AFF)
        btn.setTitle("新增", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(addTFAction), for: UIControlEvents.touchUpInside)
        btn.layer.cornerRadius = 6*kWidthRate
    
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
    //添加cell
    @objc func addTFAction() {
        //计数+1
        
        self.indexArray = [IndexPath]()
        let tag = maxTag + 1
        maxTag = tag
        self.displayArray.append(tag)
        self.tableView.reloadData()
        
        if self.displayArray.count >= 10 {
            self.addTFBtn.isEnabled = false
            self.addTFBtn.backgroundColor = UIColor.lightGray
            return
        }
    }
    //删除cell
    func deleteCell(celltag:Int) {
        for tag in 0..<self.displayArray.count {
            let index = self.displayArray[tag] as Int
                if index == celltag {
                    if celltag == maxTag {
                        maxTag = maxTag - 1
                    }
                    self.displayArray.remove(at: tag)
                    self.indexArray = [IndexPath]()
                    if self.displayArray.count == 1 {
                        maxTag = 1
                    }
                    self.tableView.reloadData()
                    break
                }
        }
        if self.displayArray.count < 10 {
            self.addTFBtn.isEnabled = true
            self.addTFBtn.backgroundColor = kColorFromHex(rgbValue: 0x007AFF)
            return
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
            if imageCellHeight != 0 {
                return imageCellHeight
            }else {
               return 200*kWidthRate
            }
            
        }else {
            return 55*kWidthRate
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imagecell", for: indexPath) as! ImageTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.tfTitleLabel.text = titletext
            var plimage:UIImage?
            if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/placeholder.png", ofType: nil) {
                let image = UIImage.init(contentsOfFile: path)!
                plimage = image
            }
            cell.imgView.sd_setImage(with: URL(string: creativeURL), placeholderImage: plimage) { [unowned self] (image, error, _, _) in
                if let dImage = image {//更新高度
                    if self.imageCellHeight != (kScreenWidth*(dImage.size.height/dImage.size.width)+50*kWidthRate) {
                        self.imageCellHeight = kScreenWidth*(dImage.size.height/dImage.size.width)+50*kWidthRate
                        print("imageCellHeight = \(self.imageCellHeight)")
                        self.tableView.reloadData()
                    }
                    
                }
                if error != nil {//图片加载失败
                    if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/placeholderFail.png", ofType: nil) {
                        let image = UIImage.init(contentsOfFile: path)!
                        cell.imgView.image = image
                    }
                }
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tfcell", for: indexPath) as! TextFieldTableViewCell
            self.indexArray.append(indexPath)
            print("indexPath = \(self.indexArray)")
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.tag = self.displayArray[indexPath.row-1]
            let plStr = String(format: "%@%ld", arguments: [placeholder,cell.tag])
            cell.tfView.textfield.attributedPlaceholder = NSAttributedString.init(string:plStr, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14*kWidthRate)])
            
            cell.tfCellSetup()
            cell.myDeleteClosure = { [unowned self] (cellTag) -> () in
                self.deleteCell(celltag: cellTag)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    deinit {
        print("fbDisplayView dealloc")
    }
}

