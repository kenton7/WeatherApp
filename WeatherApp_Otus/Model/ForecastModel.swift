//
//  CityModel.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 21.09.2023.
//

import Foundation
import RealmSwift

let realm = try! Realm()

struct ForecastModel: Codable {
    var latitude: Double?
    var longitude: Double?
    var weatherDescriptionFromServer: String = ""
    
    /// Вычисляемое свойство для регулировки описания погоды, если в описании погоды 2 и более слова, так как с сервера приходит все с маленькой буквы
    var weatherDescriptionComputed: String {
        get {
            var finalStr = ""
            let separated = weatherDescriptionFromServer.components(separatedBy: " ")
            let descriptionCapitalaized = "\(separated[0].capitalized)\n\(separated.last ?? "")"
            if separated.count == 2 {
                finalStr = descriptionCapitalaized
            } else if separated.count == 3 {
                print("here")
                finalStr = "\(separated[0].capitalized) \(separated[1])\n\(separated.last ?? "")"
                print(finalStr)
            } else {
                finalStr = weatherDescriptionFromServer.prefix(1).uppercased() + (weatherDescriptionFromServer.lowercased().dropFirst())
            }
            return finalStr
        }
    }
    var id: Int?
    var dayOrNight: String?
    var temp: Double?
    var tempMin: Double?
    var tempMax: Double?
    var pressureFromServer: Int?
    
    /// Вычислеямое свойство для давления, если юзер выберет другие единицы измерения
//    var pressureComputed: Int? {
//        get {
//            var result = 0
//            switch UserDefaults.standard.integer(forKey: "pressureIndex") {
//            case 0:
//                result = Int((Double(pressureFromServer) * 0.750064).rounded())
//            case 1:
//                result = pressureFromServer
//            case 2:
//                result = Int((Double(pressureFromServer) * 0.02953).rounded())
//            default:
//                return 0
//            }
//            return result
//        }
//    }
    var humidity: Int?
    var windSpeedFromServer: Double?
    var selectedItem: Int?
    var cityName: String?
    var date: String?
}

class ForecastRealm: Object {
    let config = Realm.Configuration(
        schemaVersion: 9)
    
    @objc dynamic var cityName: String = ""
    @objc dynamic var dayOrNight: String = ""
    @objc dynamic var weatherDescription: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var temp: Double = 0.0
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var tempMin: Double = 0.0
    @objc dynamic var tempMax: Double = 0.0
    @objc dynamic var pressure: Int = 0
    @objc dynamic var humidity: Int = 0
    @objc dynamic var windSpeed: Double = 0.0
    @objc dynamic var selectedItem: Int = 0
    @objc dynamic var date: String = ""
    
    
    //    override class func primaryKey() -> String? {
    //            return "id"
    //        }
    
    
    convenience init(cityName: String, dayOrNight: String, weatherDescription: String, id: Int, temp: Double, latitude: Double, longitude: Double, tempMin: Double, tempMax: Double, pressure: Int, humidity: Int, windSpeed: Double, selectedItem: Int, date: String) {
        self.init()
        self.cityName = cityName
        self.dayOrNight = dayOrNight
        self.weatherDescription = weatherDescription
        self.id = id
        self.temp = temp
        self.latitude = latitude
        self.longitude = longitude
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.selectedItem = selectedItem
        self.date = date
    }
}


