//
//  UserSettings.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 14.12.2023.
//

import Foundation

struct UserSettings: Codable {
    let selectedRow: Int
    let windIndex: Int
    let pressureIndex: Int
    let units: String
}
