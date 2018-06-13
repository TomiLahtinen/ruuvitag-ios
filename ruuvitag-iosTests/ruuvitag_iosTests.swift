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
        // - Humidity = 64%
        // - Temperature = 22.5 degrees Celsius
        // - Pressure = 1008 hPa
        // - Acceleration X, Y, Z all = 1000
        // - Battery voltage = 3200 mV
        let bytes: [UInt8] = [
            0x99, 0x04,  // manufacturer
            0x03,        // version
            0x80,        // humidity
            0x16, 0x50,  // temperature
            0xC7, 0x40,  // pressure
            0x03, 0xE8, 0x03, 0xE8, 0x03, 0xE8,  // acceleration
            0x0C, 0x80,  // voltage
            0x00, 0x00, 0x00, 0x00  // filler
        ]
        let payload = Data(bytes: bytes)
        let data = DataFormat3.decode(data: payload)
        print(data)
        if let d = data {
            let values = SensorValues(data: d)
            XCTAssertEqual(values.humidity, 64.0, "actual = \(values.humidity)")
            //XCTAssertEqual(values.temperature, 22.5, "actual = \(values.temperature)")
            XCTAssertEqual(values.pressure, 1008, "actual = \(values.pressure)")
            XCTAssertEqual(values.accelerationX, 1000, "actual = \(values.accelerationX)")
            XCTAssertEqual(values.accelerationY, 1000, "actual = \(values.accelerationY)")
            XCTAssertEqual(values.accelerationZ, 1000, "actual = \(values.accelerationZ)")
            XCTAssertEqual(values.voltage, 3200, "actual = \(values.voltage)")
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
