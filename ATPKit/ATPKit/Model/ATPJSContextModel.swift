//
//  ATPJSContextModel.swift
//  ATPKit
//
//  Created by yiren on 2019/1/3.
//  Copyright © 2019 Atlas Protocol. All rights reserved.
//

import UIKit
import JavaScriptCore
@objc protocol ATPJavaScriptDelegate:JSExport {
    
    var TIEStr:String {get}
    
    func getTieStr() -> String
    
    func testLog()
    
}

class ATPJSContextModel: NSObject, ATPJavaScriptDelegate {
    public var jsContext: JSContext?
    
    
    func getTieStr() -> String {
        let arr:Array = ["https://s3-us-west-2.amazonaws.com/common-assets-api.atlasp.io/images/banner/digitalAD_banner02.png"]
        let dic:[String : Any] = ["creatives": arr,
                                  "checkboxText": "에어 드롭을 받기위한 조건에 동의하십시오",
                                  "language": "kr",
                                  "message": "WEBTest"]
        let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
        var dataDecodedString = String(data: data!, encoding: String.Encoding.utf8)!
        dataDecodedString = dataDecodedString.replacingOccurrences(of: "\\", with: "")
        print("js called decodeStr = \(dataDecodedString)")
        let jsvalue = JSValue(object: dataDecodedString, in: jsContext)
        
        return dataDecodedString
    }
    
    func testLog() {
        print("js called testLog")
    }
    
    var TIEStr: String {
        let arr:Array = ["https://s3-us-west-2.amazonaws.com/common-assets-api.atlasp.io/images/banner/digitalAD_banner02.png"]
        let dic:[String : Any] = ["creatives": arr,
                                  "checkboxText": "에어 드롭을 받기위한 조건에 동의하십시오",
                                  "language": "kr",
                                  "message": "WEBTest"]
        let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
        var dataDecodedString = String(data: data!, encoding: String.Encoding.utf8)!
        dataDecodedString = dataDecodedString.replacingOccurrences(of: "\\", with: "")
        print("js called decodeStr = \(dataDecodedString)")
        return dataDecodedString
    }
}
