//
//  TextFieldTableViewCell.swift
//  ATPKit
//
//  Created by 易仁 on 2019/1/6.
//  Copyright © 2019 Atlas Protocol. All rights reserved.
//

import UIKit


class TextFieldTableViewCell: UITableViewCell,UITextFieldDelegate {
    public typealias DeleteClosure = (Int) -> ()
    public typealias TextClosure = (Int,String) -> ()
    public var myDeleteClosure:DeleteClosure?
    public var myTextClosure:TextClosure?
    public var placeholder:String = "Address"
    
    lazy var tfView:FBTextView = {
        let view = FBTextView()
        view.textfield.delegate = self
        view.textfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: UIControl.Event.editingChanged)
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        setupUI()
    }
    
    
//    convenience init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupUI()
//    }
    
    func setupUI() {
        self.contentView.addSubview(self.tfView)
        self.tfView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self)
        }
        self.tfView.deleteBtn.addTarget(self, action: #selector(deleteAction), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func deleteAction() {
        if let closeure = myDeleteClosure {
            closeure(self.tag)
        }
    }
    
    public func tfCellSetup() {
        if self.tag == 1 {
           self.tfView.hideDeleteBtn()
        }else {
            self.tfView.showDeleteBtn()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end")
        
    }
    
    @objc func textfieldDidChange(_ textField: UITextField) {
        print("tf change = \(textField.text)")
        if let text = textField.text {
            if let textClosure = myTextClosure {
                textClosure(self.tag,text)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
