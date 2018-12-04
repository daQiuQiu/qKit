//
//  ATPKitTests.swift
//  ATPKitTests
//
//  Created by Bill Lv on 2018/8/30.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import XCTest
//import Renderer
@testable import ATPKit

class ATPKitTests: XCTestCase {
  let baseEP = "http://test-ces.atpsrv.net/v1"
  let campaignID = "cbe56uvvif2m9fc3hn0og"

  private var kitBuilder: BCDelegateKit?

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    ATPKit.setup(type: TIEType.delegate.rawValue)
    kitBuilder = ATPKit.sharedInstance.getBCDelegateKit()
    let atpconfig = ATPConfig.init()
    atpconfig.setupData(baseEP: baseEP, campaignID: campaignID)
    kitBuilder?.initSDK(atpConfig: atpconfig)
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testBCDelegateKit() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let nasAddress = "n1NJP2yD5eHrWFDzydGbXXhxPXAjZvxdJJR"
  }

  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

}
