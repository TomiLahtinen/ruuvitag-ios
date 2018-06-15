//
//  ruuvitag_iosTests.swift
//  ruuvitag-iosTests
//
//  Created by Tomi Lahtinen on 12/06/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import XCTest
@testable import ruuvitag_ios

class ruuvitag_iosTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDataFormat3Decoding() {
        // Represents the following payload:
        // - Manufacturer ID = 0x0499
        // - Data format version = 3
        // - Humidity = 31%
        // - Temperature = 22.18 degrees Celsius
        // - Pressure = 998.36 hPa
        // - Acceleration X, Y, Z all = 1000
        // - Battery voltage = 2989 mV
        let bytes: [UInt8] = [
            0x99, 0x04,  // manufacturer
            0x03,        // version
            0x3E,        // humidity
            0x16, 0x12,  // temperature
            0xC2, 0xAC,  // pressure
            0x03, 0xE8, 0x03, 0xE8, 0x03, 0xE8,  // acceleration
            0x0B, 0xAD,  // voltage
            0x00, 0x00, 0x00, 0x00  // filler
        ]
        let payload = Data(bytes: bytes)
        let data = DataFormat3.decode(data: payload)
        print(data)
        if let d = data {
            let values = SensorValues(data: d)
            XCTAssertEqual(values.humidity, 31.0, "actual = \(values.humidity)")
            XCTAssertEqual(values.temperature, 22.18, "actual = \(values.temperature)")
            XCTAssertEqual(values.pressure, 998.36, "actual = \(values.pressure)")
            XCTAssertEqual(values.accelerationX, 1000, "actual = \(values.accelerationX)")
            XCTAssertEqual(values.accelerationY, 1000, "actual = \(values.accelerationY)")
            XCTAssertEqual(values.accelerationZ, 1000, "actual = \(values.accelerationZ)")
            XCTAssertEqual(values.voltage, 2989, "actual = \(values.voltage)")
        }
        else {
            XCTFail()
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
