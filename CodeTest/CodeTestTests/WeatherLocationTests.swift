//
//  WeatherLocationTests.swift
//  CodeTestTests
//
//  Created by Ajay Rawat on 2021-03-14.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import XCTest
@testable import CodeTest

class WeatherLocationTests: XCTestCase {

    func testWeatherStatus() throws {

      // Action
      let expectedValue: WeatherLocation.Status = .sunny
      let actualValue = WeatherLocation.Status(rawValue: "SUNNY")
      // Assertion
      XCTAssertEqual(expectedValue, actualValue)
    }

  func testWeatherStatusEmoji() throws {

    // Action
    let expectedValue: WeatherLocation.Status = .thunderCloudAndRain
    let actualValue = WeatherLocation.Status(rawValue: "THUNDER_CLOUD_AND_RAIN")
    // Assertion
    XCTAssertEqual(expectedValue, actualValue)
    XCTAssertEqual(expectedValue.title, "THUNDER CLOUD AND RAIN")
    XCTAssertEqual(expectedValue.emoji, "⛈")
  }

}
