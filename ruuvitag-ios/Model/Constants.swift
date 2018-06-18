//
//  Constants.swift
//  ruuvitag-ios
//
//  Created by Tomi Lahtinen on 12/06/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation

enum RTDataConstants {
    static let RuuviManufacturerID = 39172
}

protocol RTRuuviData {
    var version: Int { get }
    var data: RTRuuviData { get }
}
