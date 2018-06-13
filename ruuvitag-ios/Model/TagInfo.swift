//
//  TagInfo.swift
//  ruuvitag-ios
//
//  Created by Tomi Lahtinen on 13/06/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation

open struct TagInfo {
    let uuid: UUID
    let name: String?
    let sensorValues: SensorValues
}
