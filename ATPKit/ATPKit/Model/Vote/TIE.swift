//
//  TIE.swift
//  Renderer
//
//  Created by Bill Lv on 2018/9/1.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation

//public struct TIE: Codable {
//    public let type: TIEType
//    public let raw: String
//
//    public init(type: TIEType = .none, raw: String) {
//        self.type = type
//        self.raw = raw
//    }
//}

public class TIE: NSObject {
    @objc public var type: TIEType = TIEType.none
    
    @objc public var raw: String = ""
    
    @objc public func setupData(type: TIEType = .none, raw: String) {
        self.type = type
        self.raw = raw
    }
}

@objc public enum TIEType: Int {
    case delegate
    case original
    case none
    case error
}

@objc public enum ATPLanguageType:Int {
    case CN
    case EN
    case KR
}

public enum SDRenderState:Int {
    case begin
    case checkState
    case receipt
    case transFail
}
