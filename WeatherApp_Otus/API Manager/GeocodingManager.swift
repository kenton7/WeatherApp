//
//  GeocodingManager.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 20.09.2023.
//

import Foundation

class GeocodingManager {
    static let shared = GeocodingManager()
    
    //var geocodingData: (lat: Double, long: Double, name: String, weatherDescription: String, weatherID: Int, dayOrNight: String, temp: Double)?
    //private var forecastModel: ForecastModel?
    
    func search(city: String, completion: @escaping ((ForecastModel)) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=1&appid=\(APIKey.APIKey)") else { return }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler:  { data, resposne, error in
            guard let data = data else { return }
            
            if let geocoding = try? JSONDecoder().decode(Geocoding.self, from: data) {
                guard let latitude = geocoding.first?.lat else { return }
                guard let longtitude = geocoding.first?.lon else { return }
                //guard let name = geocoding.first?.localNames?["ru"] else { return }

                //После получения координат введенного пользователем города, отправляем запрос на получение текущей погоды по координатам
                CurrentWeatherManager.shared.getWeather(latitude: latitude, longtitude: longtitude) { forecastModel in
                    //self.geocodingData = (forecastModel.latitude ?? 0.0, forecastModel.longitude ?? 0.0, forecastModel.cityName ?? "", forecastModel.description ?? "", forecastModel.id ?? 0, forecastModel.dayOrNight ?? "d", forecastModel.temp ?? 0.0)
                    completion((ForecastModel(latitude: nil, longitude: nil, description: forecastModel.description, id: forecastModel.id, dayOrNight: String(forecastModel.dayOrNight ?? "d"), temp: forecastModel.temp, tempMin: forecastModel.tempMin, tempMax: forecastModel.tempMax, pressure: Double(forecastModel.pressure ?? 0 ), humidity: forecastModel.humidity , windSpeed: forecastModel.windSpeed , selectedItem: nil, cityName: forecastModel.cityName)))
                }
            } else {
                print("failed parsing JSON")
            }
        })
        task.resume()
    }
}
