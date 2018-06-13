//
//  DataFormat3.swift
//  ruuvitag-ios
//
//  Created by Tomi Lahtinen on 12/06/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation
import SwiftBytes

struct DataFormat3 {
    
    let manufacturer: UInt16
    let version: UInt8
    let humidity: UInt8
    let temperatureWhole: Int8
    let temperatureFraction: UInt8
    let pressure: UInt16
    let accelerationX: Int16
    let accelerationY: Int16
    let accelerationZ: Int16
    let voltage: UInt16
    let rssi: Int
    
    static func decode(data: Data?, rssi: Int = -1000) -> DataFormat3? {
        guard let dataBytes = data?.bytes else {
            return nil
        }
        if dataBytes.count != 20 {
            return nil
        }
        let result = DataFormat3(
            manufacturer: concatenateBytes(dataBytes[0], dataBytes[1]),
            version: dataBytes[2],
            humidity: dataBytes[3],
            temperatureWhole: signed(dataBytes[4]),
            temperatureFraction: dataBytes[5],
            pressure: concatenateBytes(dataBytes[6], dataBytes[7]),
            accelerationX: signed(concatenateBytes(dataBytes[8], dataBytes[9])),
            accelerationY: signed(concatenateBytes(dataBytes[10], dataBytes[11])),
            accelerationZ: signed(concatenateBytes(dataBytes[12], dataBytes[13])),
            voltage: concatenateBytes(dataBytes[14], dataBytes[15]),
            rssi: rssi)
        if result.manufacturer == DataConstants.RuuviManufacturerID {
            return result
        }
        else {
            return nil
            
        }
    }
}

public struct SensorValues {
    let humidity: Float         // percentage
    let temperature: Float      // degrees Celsius
    let pressure: Int           // hPa
    let accelerationX: Int      // mG
    let accelerationY: Int      // mG
    let accelerationZ: Int      // mG
    let voltage: Int            // millivolts
    let rssi: Int
    
    init(data rawData: DataFormat3) {
        self.humidity = Float(rawData.humidity) * 0.5
        self.temperature = Float(rawData.temperatureWhole) + (Float(rawData.temperatureFraction) / 100.0)
        self.pressure = (Int(rawData.pressure) + 50_000) / 100
        self.accelerationX = Int(rawData.accelerationX)
        self.accelerationY = Int(rawData.accelerationY)
        self.accelerationZ = Int(rawData.accelerationZ)
        self.voltage = Int(rawData.voltage)
        self.rssi = rawData.rssi
    }
}
