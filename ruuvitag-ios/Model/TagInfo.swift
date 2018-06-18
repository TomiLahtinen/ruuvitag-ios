//
//  TagInfo.swift
//  ruuvitag-ios
//
//  Created by Tomi Lahtinen on 13/06/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation

public struct RTTagInfo {
    public let uuid: UUID
    public let name: String?
    public let sensorValues: RTSensorValues
}
