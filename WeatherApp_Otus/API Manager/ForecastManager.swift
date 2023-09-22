//
//  ForecastManager.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 11.09.2023.
//

import Foundation

class ForecastManager {
    static let shared = ForecastManager()

    func getForecastWithCoordinates(latitude: Double, longtitude: Double, completion: @escaping (([(ForecastModel)])) -> Void) {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longtitude)&units=metric&lang=ru&appid=\(APIKey.APIKey)") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            if let forecast = try? JSONDecoder().decode(Forecast.self, from: data) {
                let calendar = Calendar.current
                let df = DateFormatter()

                var tupleForecastData = [ForecastModel]()
                
                let first8Items = forecast.list?.prefix(8) // берем первые 8 значений из JSON
                
                //проходимся по массиву из 8 элементов, отделяем от даты только время и добавляем нужные данные в кортеж
                for i in first8Items! {
                    let date = i.dtTxt?.components(separatedBy: "-")
                    let separatedDate = String(date?[2].components(separatedBy: " ").dropFirst().joined().prefix(5) ?? "")
                    tupleForecastData.append(ForecastModel(id: i.weather?.first?.id ?? 803, dayOrNight: i.sys?.pod?.rawValue ?? "d", temp: i.main?.temp ?? 0, date: separatedDate))
                }

                guard let forecastList = forecast.list else { return }
                for item in forecastList {
                    
                    var forecastData = [ForecastModel]()
                    let date = Date(timeIntervalSince1970: Double(forecast.list?.last?.dt ?? 0))
                    let date1 = item.dtTxt?.prefix(10)
                    let first8Items = forecast.list?.prefix(8)
                    
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
                            print(today)
                            if today >= 24 {
                                today = 00
                                print(today)
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
                    
                     //Добаввляем полученную инфу в массив кортежей
                    for data in filteredData! {
                        df.dateFormat = "EEE" // день недели
                        df.locale = Locale(identifier: "ru_RU")
                        df.timeZone = .current
                        let date = Date(timeIntervalSince1970: Double(data.dt ?? 0))
                        forecastData.append(ForecastModel(id: data.weather?[0].id ?? 803, tempMin: data.main?.tempMin ?? 0, tempMax: data.main?.tempMax, date: "\(df.string(from: date))"))
                    }
                    completion((tupleForecastData))
                }
            } else {
                print("failed parsing JSON")
            }
        }
        task.resume()
    }
}
