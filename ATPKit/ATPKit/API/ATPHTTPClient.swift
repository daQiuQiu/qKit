/*
 * Copyright (c) 2018 Atlas Protocol
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *////

import UIKit
import Foundation
import Alamofire
//import Renderer

class ATPHTTPClient {
    fileprivate var baseEP: String?
    
    lazy var manager:Alamofire.SessionManager = {
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        let alamoManager = Alamofire.SessionManager(configuration: config)
        
        return alamoManager
    }()
    
    let headers = [
        //      "Authorization": "Bearer " + kTIE,
        "Accept": "application/json",
        "Content-Type":"application/json; charset=utf-8"
    ]
    
    init(baseEP: String) {
        self.baseEP = baseEP
        
    }
    
    func getRequest(_ uri: String, completion: @escaping (NSDictionary?) -> Void,failure: @escaping (Error?) -> Void) throws {
        guard ATPConnectivity.isConnectedToInternet else {
            
            throw ATPError.net
        }
        
        manager.request(baseEP! + uri, method: .get, headers: headers).responseString(encoding: String.Encoding.utf8) { response in
            debugPrint(response)
            switch response.result {
            case .success(_):
                let data = response.result.value?.data(using: .utf8)
                if let resData = data {
                    let jsonData = try? JSONSerialization.jsonObject(with: resData, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    completion(jsonData)
                }
            case .failure(_):
                failure(response.error)
            }
        }
    }
    
    func postRequest(_ uri: String, body: String?, completion: @escaping (NSDictionary?) -> Void,failure: @escaping (Error?) -> Void) throws {
        guard ATPConnectivity.isConnectedToInternet else {
            throw ATPError.net
        }
        
        var parameters: Parameters = [:]
        let data = body?.data(using: .utf8)
        if let parameterData = data,
            let decodedParameter = try? JSONSerialization.jsonObject(with: parameterData) as! [String: Any] {
            parameters = decodedParameter
        }
        
        manager.request(baseEP! + uri
            , method: .post
            , parameters: parameters
            , encoding: JSONEncoding.prettyPrinted
            , headers: headers).debugLog()
            .responseString(encoding: String.Encoding.utf8) { response in
                debugPrint(response)
                switch response.result {
                case .success(_):
                    let data = response.result.value?.data(using: .utf8)
                    if let resData = data {
                        let jsonData = try? JSONSerialization.jsonObject(with: resData, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                        completion(jsonData)
                        
                    }
                case .failure(_):
                    failure(response.error)
                }
        }
    }
}

extension Request {
    public func debugLog() -> Self {
        debugPrint("=======================================")
        debugPrint(self)
        debugPrint("=======================================")
        return self
    }
}
