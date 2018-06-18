//
//  DataFormat3.swift
//  ruuvitag-ios
//
//  Created by Tomi Lahtinen on 12/06/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation

public struct RTDataFormat3 {
    
    public let manufacturer: UInt16
    public let version: UInt8
    public let humidity: UInt8
    public let temperatureWhole: Int8
    public let temperatureFraction: UInt8
    public let pressure: UInt16
    public let accelerationX: Int16
    public let accelerationY: Int16
    public let accelerationZ: Int16
    public let voltage: UInt16
    public let rssi: Int
    
    public static func decode(data: Data?, rssi: Int = -1000) -> RTDataFormat3? {
        guard let dataBytes = data?.bytes else {
            return nil
        }
        if dataBytes.count != 20 {
            return nil
        }
        let result = RTDataFormat3(
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
        if result.manufacturer == RTDataConstants.RuuviManufacturerID {
            return result
        }
        else {
            return nil
            
        }
    }
}

public struct RTSensorValues {
    public let humidity: Float         // percentage
    public let temperature: Float      // degrees Celsius
    public let pressure: Float         // hPa
    public let accelerationX: Int      // mG
    public let accelerationY: Int      // mG
    public let accelerationZ: Int      // mG
    public let voltage: Int            // millivolts
    public let rssi: Int
    
    public init(data rawData: RTDataFormat3) {
        self.humidity = Float(rawData.humidity) * 0.5
        self.temperature = (Float(rawData.temperatureWhole) + (Float(rawData.temperatureFraction) / 100.0))//.rounded(toPlaces: 2)
        self.pressure = (Float(rawData.pressure) + 50_000.0) / 100.0
        self.accelerationX = Int(rawData.accelerationX)
        self.accelerationY = Int(rawData.accelerationY)
        self.accelerationZ = Int(rawData.accelerationZ)
        self.voltage = Int(rawData.voltage)
        self.rssi = rawData.rssi
    }
}

extension Float {
    func rounded(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded(.down) / divisor
    }
}

