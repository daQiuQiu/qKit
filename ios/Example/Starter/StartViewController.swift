//
//  StartViewController.swift
//  Starter
//
//  Created by yiren on 2018/10/25.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit
import ATPKit
import Renderer

class StartViewController: UIViewController {
    lazy var textfield: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
        textfield.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 80)
        textfield.layer.borderColor = UIColor.darkGray.cgColor
        textfield.layer.borderWidth = 1.0
        textfield.adjustsFontSizeToFitWidth = true
        return textfield
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(endInput))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        setupUI()
    }
    func setupUI() {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        btn.setTitle("Go to Vote", for: .normal)
        btn.center = self.view.center
        btn.backgroundColor = .darkGray
        btn.addTarget(self, action: #selector(goToVote(btn:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn)
        
        
        self.view.addSubview(self.textfield)
        
    }
    @objc func goToVote(btn:UIButton) {
        let voteVC = VotingViewController()
        if let nasAddr = self.textfield.text {
            voteVC.nasAddress = nasAddr
            voteVC.lang = LanguageType.EN
            let kitBuilder: KitBuilder = KitFactory.sharedInstance.getKitBuilder()
            kitBuilder.delegate = voteVC
            self.navigationController?.pushViewController(voteVC, animated: true)
        }
    }
    
    @objc func endInput() {
        self.view.endEditing(true)
    }
    
}
