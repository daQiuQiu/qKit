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

class FBDisplayView: UIView,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler{
    
    public typealias CheckClosure = (Bool) -> ()
    public var myCheckClosure:CheckClosure?
    var isSelected:Bool = false
    
    
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
    
    lazy var displayWebview: WKWebView = {
        let config = WKWebViewConfiguration()
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
        preference.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = preference
        
        config.processPool = WKProcessPool()
        config.userContentController = WKUserContentController()
        config.userContentController.add(self, name: "getTieStr")
        
        let webview = WKWebView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), configuration: config)
        webview.navigationDelegate = self
        webview.uiDelegate = self

        return webview
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
        self.addSubview(self.displayWebview)
        
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
        self.displayWebview.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.topLabel.snp.bottom)
            make.bottom.equalTo(self)
        }
    }
    
    public func startLoading() {
        let request = URLRequest(url:URL(string: "http://192.168.20.113:5000")!)
//        let request = URLRequest(url:URL(string: "http://www.baidu.com/")!)
        displayWebview.load(request)
    }
    
    func callJS() {
//        self.displayWebview.evaluateJavaScript("getTieStr()") { (object, error) in
//            print("obj = \(object), error = \(error)")
//        }
        
        let jscontext = displayWebview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
//        jscontext["getTieStr"] = { [unowned self] () -> () in
//            print("in processing js context")
//            return "aaaaa"
//        }
        jscontext.exceptionHandler = {context, exception in
            if let exp = exception {
                print("js exception = \(exp.toString())")
            }
        }
        if let functionName = jscontext.objectForKeyedSubscript("getTieStr") {
            if let fullname = functionName.call(withArguments: ["aaaa"]) {
                print("result = \(fullname.toString())")
            }
        }
        
    }
    
    //MARK: Webview delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("navi finish")
        
        callJS()
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        //处理跳转
        print("creatNewWindow url = \(navigationAction.request)")
        return nil
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("web start")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("web error = \(error.localizedDescription)")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("receive")
        if (message.name == "getTieStr") {
            
            print("receive js TIE signal")
        }
    }
}

