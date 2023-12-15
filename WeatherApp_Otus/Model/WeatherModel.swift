//
//  WeatherModel.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 09.09.2023.
//

import Foundation

struct APIKey {
    static let apiKey = "bf6b4e4a53e89885bc70f0045874c122"
}

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}

// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    let weather: [Weather]?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    //let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let name: String?
    let cod: Int?
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.weather = try container.decodeIfPresent([Weather].self, forKey: .weather)
        self.main = try container.decodeIfPresent(Main.self, forKey: .main)
        self.visibility = try container.decodeIfPresent(Int.self, forKey: .visibility)
        self.wind = try container.decodeIfPresent(Wind.self, forKey: .wind)
        self.dt = try container.decodeIfPresent(Int.self, forKey: .dt)
        self.sys = try container.decodeIfPresent(Sys.self, forKey: .sys)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.cod = try container.decodeIfPresent(Int.self, forKey: .cod)
    }
    
    enum CodingKeys: CodingKey {
        case weather
        case main
        case visibility
        case wind
        case dt
        case sys
        case name
        case cod
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.weather, forKey: .weather)
        try container.encodeIfPresent(self.main, forKey: .main)
        try container.encodeIfPresent(self.visibility, forKey: .visibility)
        try container.encodeIfPresent(self.wind, forKey: .wind)
        try container.encodeIfPresent(self.dt, forKey: .dt)
        try container.encodeIfPresent(self.sys, forKey: .sys)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.cod, forKey: .cod)
    }
}



// MARK: - Clouds
//struct Clouds: Codable {
//    let all: Int?
//}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double?
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: Pod?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}

struct WeatherModel: Codable {
    //let cod: String?
    //let message, cnt: Int?
    let list: [List]?
    let city: City?
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

// MARK: - Forecast
struct Forecast: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [List]?
    let city: City?
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [Weather]?
    //let clouds: Clouds?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let sys: Sys?
    let dtTxt: String?
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, /*clouds*/ wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try container.decodeIfPresent(Int.self, forKey: .dt)
        self.main = try container.decodeIfPresent(MainClass.self, forKey: .main)
        self.weather = try container.decodeIfPresent([Weather].self, forKey: .weather)
        self.wind = try container.decodeIfPresent(Wind.self, forKey: .wind)
        self.visibility = try container.decodeIfPresent(Int.self, forKey: .visibility)
        self.pop = try container.decodeIfPresent(Double.self, forKey: .pop)
        self.sys = try container.decodeIfPresent(Sys.self, forKey: .sys)
        self.dtTxt = try container.decodeIfPresent(String.self, forKey: .dtTxt)
        self.rain = try container.decodeIfPresent(Rain.self, forKey: .rain)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.dt, forKey: .dt)
        try container.encodeIfPresent(self.main, forKey: .main)
        try container.encodeIfPresent(self.weather, forKey: .weather)
        try container.encodeIfPresent(self.wind, forKey: .wind)
        try container.encodeIfPresent(self.visibility, forKey: .visibility)
        try container.encodeIfPresent(self.pop, forKey: .pop)
        try container.encodeIfPresent(self.sys, forKey: .sys)
        try container.encodeIfPresent(self.dtTxt, forKey: .dtTxt)
        try container.encodeIfPresent(self.rain, forKey: .rain)
    }
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

enum Description: String, Codable {
    case небольшаяОблачность = "небольшая облачность"
    case небольшойДождь = "небольшой дождь"
    case облачноСПрояснениями = "облачно с прояснениями"
    case пасмурно = "пасмурно"
    case переменнаяОблачность = "переменная облачность"
    case ясно = "ясно"
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}



