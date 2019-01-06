//
//  TextFieldTableViewCell.swift
//  ATPKit
//
//  Created by 易仁 on 2019/1/6.
//  Copyright © 2019 Atlas Protocol. All rights reserved.
//

import UIKit


class TextFieldTableViewCell: UITableViewCell {
    public typealias DeleteClosure = (Int) -> ()
    public var myDeleteClosure:DeleteClosure?
    
    lazy var tfView:FBTextView = {
        let view = FBTextView()
        
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI() {
        self.addSubview(self.tfView)
        self.tfView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self)
        }
        self.tfView.deleteBtn.addTarget(self, action: #selector(deleteAction), for: UIControlEvents.touchUpInside)
    }
    
    @objc func deleteAction() {
        if let closeure = myDeleteClosure {
            closeure(self.tag)
        }
    }

}
