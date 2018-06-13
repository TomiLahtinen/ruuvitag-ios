//
//  BLEController.swift
//  ruuvitag-ios
//
//  Created by Tomi Lahtinen on 12/06/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation
import CoreBluetooth

public protocol RuuviTagsProtocol {
    func startScanning()
    func stopScanning()
}

class RuuviTagConnector: NSObject, RuuviTagsProtocol {

    private let advertisementData: (SensorValues) -> ()
    private var centralManager: CBCentralManager
    private let dataDispatchQueue = DispatchQueue(label: "RuuviData_DispatchQueue")
    
    public static func create(onDataReceived: @escaping (SensorValues) -> ()) -> RuuviTagsProtocol {
        let tags = RuuviTagConnector(onDataReceived)
        tags.startScanning()
        return tags
    }
    
    private init(_ advertisementData: @escaping (SensorValues) -> ()) {
        self.advertisementData = advertisementData
        self.autoStart = autoStart
        
        let opts = [CBCentralManagerScanOptionSolicitedServiceUUIDsKey: true,
                    CBCentralManagerOptionShowPowerAlertKey: true,
                    CBCentralManagerScanOptionAllowDuplicatesKey: true]
        self.centralManager = CBCentralManager(delegate: nil, queue: self.dataDispatchQueue, options: opts)
        
        super.init()
        centralManager.delegate = self
    }
    
    public func startScanning() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    public func stopScanning() {
        centralManager.stopScan()
    }
}

extension RuuviTagConnector: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch centralManager.state {
        case .poweredOn:
            if autoStart {
                centralManager.scanForPeripherals(withServices: nil, options: nil)
            }
        default:
            debugPrint("Central manager state", centralManager.state)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey],
            let rawData = DataFormat3.decode(data: manufacturerData as? Data, rssi: RSSI.intValue) {
            debugPrint("RuuviTag data received", peripheral.identifier, "rssi", RSSI)
            self.advertisementData(SensorValues.init(data: rawData))
        }
    }
}
