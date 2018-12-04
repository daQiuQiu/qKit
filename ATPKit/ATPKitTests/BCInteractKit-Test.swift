//
//  BCInteractKit-Test.swift
//  ATPKitTests
//
//  Created by yiren on 2018/11/21.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import XCTest
@testable import ATPKit

class BCInteractKit_Test: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ATPKit.setup(type: TIEType.original.rawValue)
        let kit = ATPKit.sharedInstance.getBCinteractKit()
        let config = BCIConfig.init(language: ATPLanguageType.CN.rawValue, partnerID: "111")
        kit?.setConfig(bciConfig: config)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let kit = ATPKit.sharedInstance.getBCinteractKit()
        let canRender =  kit?.isRenderable(payload: "rgFuMW02QkRKSlQ2WFlGaFpicWM2SldZM1g2U0pFS1FRVzd1Qg==")
        
        XCTAssert(canRender!)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            for index in 1..<1000 {
                print("index = \(index)")
            }
        }
    }

}
