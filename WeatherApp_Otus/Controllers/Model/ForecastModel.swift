//
//  CityModel.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 21.09.2023.
//

import Foundation

struct ForecastModel {
    var latitude: Double?
    var longitude: Double?
    var description: String?
    var id: Int?
    var dayOrNight: String?
    var temp: Double?
    var tempMin: Double?
    var tempMax: Double?
    var pressure: Double?
    var humidity: Int?
    var windSpeed: Double?
    var selectedItem: Int?
    var cityName: String?
    var date: String?
}

