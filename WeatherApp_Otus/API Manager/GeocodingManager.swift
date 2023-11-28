//
//  GeocodingManager.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 20.09.2023.
//

import Foundation

class GeocodingManager {
    static let shared = GeocodingManager()
    
    
    /// Функция для поиска города и запроса погоды в этом городе
    /// - Parameters:
    ///   - city: Город
    ///   - completion: в комплишине используем модель прогноза погоды
    func search(city: String, completion: @escaping (ForecastModel) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=1&appid=\(APIKey.apiKey)") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler:  { data, _, _ in
            guard let data = data else { return }
            
            if let geocoding = try? JSONDecoder().decode(Geocoding.self, from: data) {
                guard let latitude = geocoding.first?.lat else { return }
                guard let longitude = geocoding.first?.lon else { return }
                
                //guard let name = geocoding.first?.localNames?["ru"] else { return }

                //После получения координат введенного пользователем города, отправляем запрос на получение текущей погоды по координатам
                CurrentWeatherManager.shared.getWeather(latitude: latitude, longtitude: longitude) { forecastModel in
                    completion((ForecastModel(latitude: latitude,
                                              longitude: longitude,
                                              weatherDescriptionFromServer: forecastModel.weatherDescriptionFromServer,
                                              id: forecastModel.id,
                                              dayOrNight: String(forecastModel.dayOrNight ?? "d"),
                                              temp: forecastModel.temp,
                                              tempMin: forecastModel.tempMin,
                                              tempMax: forecastModel.tempMax,
                                              pressureFromServer: forecastModel.pressureFromServer,
                                              humidity: forecastModel.humidity,
                                              windSpeedFromServer: forecastModel.windSpeedFromServer,
                                              selectedItem: nil,
                                              cityName: geocoding.first?.localNames?["ru"],
                                              date: forecastModel.date)))
                }
            } else {
                print("failed parsing JSON")
            }
        })
        task.resume()
    }
}
