//
//  CurrentWeatherService.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 12.12.2023.
//

import Foundation

enum Language: String {
    case ru = "ru"
    case en = "en"
}

enum WeatherEndpoints: URLRequestConvertable {
    case currentWeather(latitude: Double, longitude: Double, units: String, lang: Language)
    case forecast(latitude: Double, longitude: Double, units: String, lang: Language)
    case geo(city: String)
    
    var path: String {
        switch self {
        case .currentWeather:
            return "/data/2.5/weather"
        case .forecast:
            return "/data/2.5/forecast"
        case .geo:
            return "/geo/1.0/direct"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var urlQuery: [String : String] {
        
        if let coordinates = UserDefaults.standard.data(forKey: "coordinates") {
            let decodedCoordinates = try! JSONDecoder().decode(Coordinates.self, from: coordinates)
            
            if path == "/data/2.5/weather" || path == "/data/2.5/forecast" {
                return ["lat": "\(decodedCoordinates.latitude)", "lon": "\(decodedCoordinates.longitude)", "lang": "\(Language(rawValue: "ru")!)", "appid": "\(APIKey.apiKey)", "units": "\(UserDefaults.standard.string(forKey: "units") ?? "metric")"]
            } else {
                return ["q": "\(UserDefaults.standard.string(forKey: "city") ?? "")", "limit": "1", "appid": "\(APIKey.apiKey)"]
            }
        }
        return ["": ""]
    }
}


final class CurrentWeatherService {
    
    private let client: RestApiClient
    
    init(client: RestApiClient = .init() ) {
        self.client = client
    }
    
    func getCurrentWeather(longitute: Double, latitude: Double, units: String, language: Language, completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
                
        client.performRequest(WeatherEndpoints.currentWeather(latitude: latitude, longitude: longitute, units: units, lang: language)) { result in
            
            switch result {
            case .success(let data):
                let weather = try! JSONDecoder().decode(CurrentWeather.self, from: data)
                completion(.success(weather))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getForecast(longitude: Double, latitide: Double, units: String, lang: Language, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        
        client.performRequest(WeatherEndpoints.forecast(latitude: latitide, longitude: longitude, units: units, lang: lang)) { result in
            
            switch result {
            case .success(let data):
                let forecast = try! JSONDecoder().decode(WeatherModel.self, from: data)
                
                //let first8Items = forecast.list?.prefix(8) // берем первые 8 значений из JSON
                
                completion(.success(forecast))
                
//                let forecastData = [WeatherModel]()
//                //проходимся по массиву из 8 элементов, отделяем от даты только время и добавляем нужные данные в массив
//                for i in first8Items! {
//                    let date = i.dtTxt?.components(separatedBy: "-")
//                    let separatedDate = String(date?[2].components(separatedBy: " ").dropFirst().joined().prefix(5) ?? "")
//                    forecastData.append(<#T##newElement: WeatherModel##WeatherModel#>)
//                    completion(.success(forecastData))
//                }
                completion(.success(forecast))
                
                //completion(.success(forecast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func weatherByGeo(city: String, completion: @escaping (Result<[GeocodingElement], Error>) -> Void) {
        client.performRequest(WeatherEndpoints.geo(city: city)) { result in
            switch result {
            case .success(let data):
                let city = try! JSONDecoder().decode([GeocodingElement].self, from: data)
                completion(.success(city))

            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
