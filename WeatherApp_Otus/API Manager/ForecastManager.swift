//
//  ForecastManager.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 11.09.2023.
//

import Foundation

class ForecastManager {
    static let shared = ForecastManager()

    
    /// Функция для получения прогноза погоды на сутки по координатам
    /// - Parameters:
    ///   - latitude: широта
    ///   - longtitude: долгота
    ///   - completion: модель прогноза погоды
    func getForecastWithCoordinates(latitude: Double, longtitude: Double, completion: @escaping ([ForecastModel]) -> Void) {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longtitude)&units=\(UserDefaults.standard.string(forKey: "units") ?? "metric")&lang=ru&appid=\(APIKey.APIKey)") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            
            if let forecast = try? JSONDecoder().decode(Forecast.self, from: data) {

                var forecastData = [ForecastModel]()
                
                let first8Items = forecast.list?.prefix(8) // берем первые 8 значений из JSON
                
                //проходимся по массиву из 8 элементов, отделяем от даты только время и добавляем нужные данные в массив
                for i in first8Items! {
                    let date = i.dtTxt?.components(separatedBy: "-")
                    let separatedDate = String(date?[2].components(separatedBy: " ").dropFirst().joined().prefix(5) ?? "")
                    forecastData.append(ForecastModel(id: i.weather?.first?.id ?? 803, 
                                                           dayOrNight: i.sys?.pod?.rawValue ?? "d",
                                                           temp: i.main?.temp ?? 0,
                                                           tempMin: i.main?.tempMin ?? 0.0,
                                                           tempMax: i.main?.tempMax ?? 0.0,
                                                           date: separatedDate))
                }
                    completion((forecastData))
            } else {
                print("failed parsing JSON")
            }
        }
        task.resume()
    }
    
    
    /// Отдельная функция для получения прогноза погоды на КАЖДЫЙ день (без разделения прогноза по 3 часа)
    /// - Parameters:
    ///   - latitude: широта
    ///   - longtitude: долгтоа
    ///   - completion: модель прогноза погоды
    func getForecast(latitude: Double, longtitude: Double, completion: @escaping ([ForecastModel]) -> Void) {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longtitude)&units=\(UserDefaults.standard.string(forKey: "units") ?? "metric")&lang=ru&appid=\(APIKey.APIKey)") else { return }
        let request = URLRequest(url: url)
        let calendar = Calendar.current
        let df = DateFormatter()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            if let forecast = try? JSONDecoder().decode(Forecast.self, from: data) {

                guard let forecastList = forecast.list else { return }
                for _ in forecastList {

                    var forecastData = [ForecastModel]()

//                    Фильтруем дату для каждого дня в определенное время, которое зависит от текущего часа (Например, сейчас 15:00), значит прогноз на другие дни показывается тоже в 15:00
                    let filteredData = forecast.list?.filter { entry in

                        //8 дат в сутки
                        let date = Date(timeIntervalSince1970: Double(entry.dt ?? 0))

                        //так как по API прогноз каждые 3 часа, то проверяем делится ли время (часы) на 3, если да, то просто сравниваем с текущим часом
                        if calendar.component(.hour, from: Date()) == 00 {
                            return calendar.component(.hour, from: date) == 00
                        } else if calendar.component(.hour, from: Date()) % 3 == 0 {
                            return calendar.component(.hour, from: date) == calendar.component(.hour, from: Date())
                        } else if calendar.component(.hour, from: Date()) % 3 == 1 {
                            var today = calendar.component(.hour, from: Date()) + 2
                            if today >= 24 {
                                today = 00
                            }
                            return calendar.component(.hour, from: date) == today
                        } else if calendar.component(.hour, from: Date()) % 3 == 2 {
                            var today = calendar.component(.hour, from: Date()) + 1
                            if today >= 24 {
                                today = 00
                            }
                            return calendar.component(.hour, from: date) == today
                        } else {
                            return calendar.component(.hour, from: date) == 15
                        }
                    }
                    
//                     Добаввляем полученную инфу в массив
                    for data in filteredData! {
                        df.dateFormat = "EEEE" // день недели
                        df.locale = Locale(identifier: "ru_RU")
                        df.timeZone = .current
                        let date = Date(timeIntervalSince1970: Double(data.dt ?? 0))
                        forecastData.append(ForecastModel(weatherDescription: data.weather?[0].description ,id: data.weather?[0].id ?? 803, tempMin: data.main?.tempMin ?? 0, tempMax: data.main?.tempMax, date: "\(df.string(from: date))"))
                    }
                    completion((forecastData))
                }
            } else {
                print("failed parsing JSON")
            }
        }
        task.resume()
    }
}
