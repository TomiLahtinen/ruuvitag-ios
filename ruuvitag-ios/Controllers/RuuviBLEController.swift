//
//  BLEController.swift
//  ruuvitag-ios
//
//  Created by Tomi Lahtinen on 12/06/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation
import CoreBluetooth

public protocol RTRuuviTagsProtocol {
    func startScanning()
    func stopScanning()
}

open class RTRuuviTags {
    public static func listen(forAdvertisement dataReceived: @escaping (RTTagInfo) -> ()) -> RTRuuviTagsProtocol {
        return RTRuuviTagConnector(dataReceived)
    }
}

fileprivate class RTRuuviTagConnector: NSObject, RTRuuviTagsProtocol {

    private let advertisementData: (RTTagInfo) -> ()
    private var centralManager: CBCentralManager
    private let dataDispatchQueue = DispatchQueue(label: "RuuviData_DispatchQueue")
    
    fileprivate init(_ advertisementData: @escaping (RTTagInfo) -> ()) {
        self.advertisementData = advertisementData
        
        let opts = [CBCentralManagerScanOptionSolicitedServiceUUIDsKey: true,
                    CBCentralManagerOptionShowPowerAlertKey: true,
                    CBCentralManagerScanOptionAllowDuplicatesKey: true]
        self.centralManager = CBCentralManager(delegate: nil, queue: self.dataDispatchQueue, options: opts)
        
        super.init()
        centralManager.delegate = self
    }
    
    fileprivate func startScanning() {
        if !centralManager.isScanning {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    fileprivate func stopScanning() {
        if centralManager.isScanning {
            centralManager.stopScan()
        }
    }
}

extension RTRuuviTagConnector: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch centralManager.state {
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        default:
            debugPrint("Central manager state", centralManager.state)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey],
            let rawData = RTDataFormat3.decode(data: manufacturerData as? Data, rssi: RSSI.intValue) {
            let sensorValues = RTSensorValues.init(data: rawData)
            self.advertisementData(RTTagInfo(uuid: peripheral.identifier, name: peripheral.name, sensorValues: sensorValues))
        }
    }
}
