//
//  APIManager.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 08.09.2023.
//

import Foundation

class CurrentWeatherManager {
    
    static let shared = CurrentWeatherManager()
    
    
    /// Get current weather on user's location
    /// - Parameters:
    ///   - latitude: latitude
    ///   - longtitude: longitude
    ///   - completion: Model
    func getWeather(latitude: Double, longtitude: Double, completion: @escaping ((ForecastModel)) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longtitude)&units=\(UserDefaults.standard.string(forKey: "units") ?? "metric")&lang=ru&appid=\(APIKey.apiKey)") else { return }
        print(url)
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data else { return }
            
            if let weatherData = try? JSONDecoder().decode(CurrentWeather.self, from: data) {
                completion((ForecastModel(latitude: latitude,
                                          longitude: longtitude,
                                          weatherDescriptionFromServer: weatherData.weather?[0].description ?? "",
                                          id: weatherData.weather?[0].id ?? 803,
                                          dayOrNight: String(weatherData.weather?[0].icon?.last ?? "d"),
                                          temp: weatherData.main?.temp,
                                          tempMin: weatherData.main?.tempMin,
                                          tempMax: weatherData.main?.tempMax,
                                          pressureFromServer: weatherData.main?.pressure ?? 0,
                                          humidity: weatherData.main?.humidity ?? 0,
                                          windSpeedFromServer: weatherData.wind?.speed ?? 0.0,
                                          selectedItem: nil,
                                          cityName: weatherData.name,
                                          date: String(weatherData.dt ?? 0))))
            } else {
                print("failed parsing JSON")
            }
        }
        task.resume()
    }
}

