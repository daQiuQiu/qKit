//
//  ImageTableViewCell.swift
//  
//
//  Created by 易仁 on 2019/1/6.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    public lazy var imgView: UIImageView = {
        let imagev = UIImageView()
        imagev.isUserInteractionEnabled = true
        imagev.contentMode = UIView.ContentMode.scaleAspectFit
//        imagev.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 380*kHeightRate)
        if let path = Bundle.main.path(forResource: "Frameworks/ATPKit.framework/placeholder.png", ofType: nil) {
            let image = UIImage.init(contentsOfFile: path)!
            imagev.image = image
        }else {
            //            print("no path!!!")
        }
        return imagev
    }()
    
    public lazy var tfTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = kColorFromHex(rgbValue: 0x7A7A7A)
        label.font = UIFont.systemFont(ofSize: 16*kWidthRate)
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
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
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true
        setupUI()
    }
    
    func setupUI() {
        self.contentView.addSubview(imgView)
        self.contentView.addSubview(tfTitleLabel)
        
        self.imgView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(0*kWidthRate)
            make.right.equalTo(self).offset(0*kWidthRate)
            make.bottom.equalTo(self).offset(-50*kWidthRate)
        }
        self.tfTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgView).offset(10*kWidthRate)
            make.bottom.equalTo(self)
            make.right.equalTo(self.imgView).offset(-10*kWidthRate)
        }
    }

}
