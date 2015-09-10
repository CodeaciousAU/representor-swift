//
//  HALAdapterTests.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation
import XCTest
import Representor

class HALAdapterTests: XCTestCase {
  func fixture() -> [String:AnyObject] {
    return JSONFixture("poll.hal", forObject: self)
  }

  func testConversionFromHAL() {
    let representor = deserializeHAL(fixture()) as Representor<HTTPTransition>
    let representorFixture = PollFixture(self)

    XCTAssertEqual(representor, representorFixture)
  }

  func testConversionToHAL() {
    let representor = PollFixture(self)
    let representation = serializeHAL(representor)

    XCTAssertEqual(representation as NSObject, fixture() as NSObject)
  }
}
