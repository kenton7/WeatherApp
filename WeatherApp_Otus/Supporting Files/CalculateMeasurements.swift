//
//  CalculateMeasurements.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 29.09.2023.
//

import Foundation

class CalculateMeasurements {
    static let shared = CalculateMeasurements()
    
    func calculatePressure(measurementIndex: Int, value: Int) -> Int {
        var result = 0
        switch measurementIndex {
        case 0:
            result = Int((Double(value) * 0.750064).rounded())
        case 1:
            result = value
        case 2:
            result = Int((Double(value) * 0.02953).rounded())
        default:
            return 0
        }
        return result
    }
    
    func calculateWindSpeed(measurementIndex: Int, value: Double) -> Int {
        var result = 0
        switch measurementIndex {
        case 0:
            result = Int(value.rounded())
        case 1:
            result = Int((value * 3.6).rounded())
        case 2:
            result = Int((value * 2.2369362920544).rounded())
        default:
            return 0
        }
        return result
    }
}
