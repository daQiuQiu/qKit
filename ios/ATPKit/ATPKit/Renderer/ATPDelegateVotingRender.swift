//
//  ATPDelegateVotingRender.swift
//  Renderer
//
//  Created by Bill Lv on 2018/8/31.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit
import DLRadioButton
import Foundation

open class ATPDelegateVotingRender: UIViewController, ATPRenderer,ATPDelegateVotingRenderDelegate{

    // MARK: ------------Variables--------------
    weak public var delegate: ATPDelegateVotingRenderDelegate?
    
    lazy var voteToolbar: UIToolbar = {
        let screenh = self.view.frame.height
        let screenw = self.view.frame.width
        let voteToolBar = UIToolbar(frame: CGRect(x: 0, y: screenh - 44, width: screenw, height: 44))
        return voteToolBar
    }()
    @objc lazy public var hud:UIView? = {
        let sv = ATPDelegateVotingRender.displaySpinner(onView: self.view)
        return sv
    }()
    fileprivate var allProjects = [String]()
    
    fileprivate var currentIndex = -1
    fileprivate var headButton: DLRadioButton?
    
    @objc public var nasAddress: String?
    @objc public var campaignID: String?
    fileprivate var allowToast:Bool = true
    fileprivate var allowLoading:Bool = true
    public var lang: Int = 0
    fileprivate var question: String?
    fileprivate var message: String?
    
    
    
    // MARK: ------------Lifecycle---------------
    override open func viewDidLoad() {
        super.viewDidLoad()
        //        setupKit()
        self.view.backgroundColor = .white
        
        
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //        setupKit()
    }
    
    //MARK:-------------Setup UI------------------
    func setUI() {
        if let nasAddr = self.nasAddress {
            showSpinner()
            if let delegate = self.delegate {
                delegate.register(nasAddress: nasAddr, completion: { voteData in
                    if let data = voteData {
                        self.allProjects = data.options
                        self.question = data.question
                        self.message = data.message
                        self.render()
                        self.hideSpinner()
                    }
                }) { fail in
                    self.hideSpinner()
                }
            }
        }
    }
    
    func unsetComponents() {
        if (voteToolbar.items?.count)! > 2 {
            (voteToolbar.items![1] as UIBarButtonItem).isEnabled = false
        }
    }
    
    func setComponents() {
        if allProjects.count == 0 {
            print("no project")
            return
        }
        
        let subviews: [UIView] = self.view.subviews
        
        if subviews.count > 4 {
            for index in 4..<subviews.count {
                let subview: UIView = subviews[index]
                subview.removeFromSuperview()
            }
        }
        self.view.addSubview(voteToolbar)
        if question != nil {
            _ = createLabel(frame: CGRect(x: self.view.frame.size.width / 2 - 131, y: 70, width: 262, height: 17), text: question!)
        }
        
        let frame = CGRect(x: self.view.frame.size.width / 2 - 131, y: 110, width: 262, height: 17)
        headButton = createRadioButton(frame: frame, title: allProjects[0], color: UIColor.blue)
        
        if allProjects.count < 2 {
            return
        }
        
        var otherButtons: [DLRadioButton] = []
        
        for index in 1..<allProjects.count {
            let project = allProjects[index]
            let frame = CGRect(x: self.view.frame.size.width / 2 - 131, y: 140 + 30 * CGFloat(index - 1), width: 262, height: 17)
            let radioButton = createRadioButton(frame: frame, title: project, color: UIColor.blue)
            otherButtons.append(radioButton)
        }
        
        headButton?.otherButtons = otherButtons
        
        loadPreviousState()
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let title = Bundle.getATPLocalizedString(forkey: "vote", type: ATPLanguageType(rawValue: self.lang)!)
        print("vote button title = \(title)")
        let voteButton = UIBarButtonItem(title: title, style: .plain, target: self, action: Selector.voteProject)
        let toolbarButtonItems = [space, voteButton, space]
        voteToolbar.setItems(toolbarButtonItems, animated: true)
        (voteToolbar.items![1] as UIBarButtonItem).isEnabled = (currentIndex != -1)
        
    }
    
    //MARK:-------------ATPRender Protocol Method------------------
    public func render() {
        setComponents()
        
        NotificationCenter.default.addObserver(self, selector: Selector.saveCurrentState
            , name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    public func emitEvent(atpEvent: Any) {
        let option: String = atpEvent as! String
        let votedata = BCDVote.init()
        if let campID = campaignID {
            votedata.setupData(nasAddress: nasAddress!, campaignID: campID, answer: option)
            self.showSpinner()
            if let delegate = self.delegate {
                delegate.interact(vote: votedata, completion: { complete in
                    self.hideSpinner()
                }) { fail in
                    self.hideSpinner()
                }
            }
        }
    }
    
    public func dispose() {
        
    }
    
    // MARK: -----------Memento Pattern--------------
    @objc func saveCurrentState() {
        // When the user leaves the app and then comes back again, he wants it to be in the exact same state
        // he left it. In order to do this we need to save the currently displayed project.
        // Since it's only one piece of information we can use NSUserDefaults.
        //    UserDefaults.standard.set(currentIndex, forKey: Constants.indexRestorationKey)
    }
    
    func loadPreviousState() {
        //    currentIndex = UserDefaults.standard.integer(forKey: Constants.indexRestorationKey)
        if currentIndex == -1 {
            headButton?.isSelected = false
            headButton?.otherButtons.forEach { option in
                option.isSelected = false
            }
        } else if currentIndex == 0 {
            headButton?.isSelected = true
        } else {
            if let count = headButton?.otherButtons.count, count < currentIndex {
                headButton?.otherButtons[count - 1].isSelected = true
            } else {
                headButton?.otherButtons[currentIndex - 1].isSelected = true
            }
        }
    }
    //MARK: -------------Private Method----------------
    @objc public func setupConfig(nasAddress: String, campaignID:String, allowToast:Bool, allowLoading:Bool,lang:ATPLanguageType) {
        self.nasAddress = nasAddress;
        self.campaignID = campaignID;
        self.allowToast = allowToast;
        self.allowLoading = allowLoading;
        self.lang = lang.rawValue
        
        setUI()
    }
    
    @objc func voteProject() {
        let votedProject = allProjects[currentIndex]
        print("project", votedProject)
        emitEvent(atpEvent: String(currentIndex))
    }
    
    @objc private func doneButtonAction() {
        navigationItem.titleView?.endEditing(true)
    }
    @objc private func logSelectedButton(radioButton: DLRadioButton) {
        let project: String = radioButton.selected()!.titleLabel!.text!
        print(String(format: "%@ is selected.\n", project))
        currentIndex = allProjects.index {
            $0 == project
            }!
        if currentIndex == 0 {
            headButton?.otherButtons.forEach {
                $0.isSelected = false
            }
        } else {
            headButton?.isSelected = false
            headButton?.otherButtons.forEach {
                $0.isSelected = false
            }
            radioButton.isSelected = true
        }
        (voteToolbar.items![1] as UIBarButtonItem).isEnabled = (currentIndex != -1)
    }
    
    public func showSpinner() {
        self.hud?.isHidden = false
    }
    
    public func hideSpinner() {
        if let rhud = self.hud {
            ATPDelegateVotingRender.removeSpinner(spinner: rhud)
        }
        
    }
    
    // MARK: Helper
    private func createLabel(frame: CGRect, text: String) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = text
        label.textAlignment = .left
        self.view.addSubview(label)
        
        return label
    }
    
    private func createRadioButton(frame: CGRect, title: String, color: UIColor) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame)
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        radioButton.setTitle(title, for: [])
        radioButton.setTitleColor(color, for: [])
        radioButton.iconColor = color
        radioButton.indicatorColor = color
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        radioButton.addTarget(self, action: #selector(logSelectedButton), for: UIControlEvents.touchUpInside)
        radioButton.isMultipleSelectionEnabled = false
        radioButton.isMultipleTouchEnabled = false
        self.view.addSubview(radioButton)
        
        return radioButton
    }
    
    //MARK:----------ATPDelegateVotingRenderDelegate Method to be implemented------------
    public func register(nasAddress: String, completion: @escaping (BCDVoteData?) -> Void, failure: @escaping (String?) -> Void) {
        print("delegate register")
    }
    
    public func interact(vote: BCDVote, completion: @escaping (String?) -> Void, failure: @escaping (String?) -> Void) {
        print("delegate interact")
    }

    //MARK:-----------dealloc--------------
    deinit {
        print("deinit class \(String(describing: object_getClass(self)))")
    }
    
}

//MARK:-----------Extension-------------

fileprivate extension Selector {
    static let voteProject = #selector(ATPDelegateVotingRender.voteProject)
    static let saveCurrentState = #selector(ATPDelegateVotingRender.saveCurrentState)
}

enum ValidationError: Error {
    case invalidError(message: String)
}


