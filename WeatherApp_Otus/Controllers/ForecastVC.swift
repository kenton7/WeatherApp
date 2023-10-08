//
//  ForecastVC.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 21.09.2023.
//

import UIKit

final class ForecastVC: UIViewController {
    
    private let forecastViews = ForecastViews()
    var forecastModel = [ForecastModel]()
    var coordinates: Coordinates?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Прогноз на 5 дней"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        forecastViews.configure(on: view)
        forecastViews.tableView.delegate = self
        forecastViews.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.alpha = 1.0
        ForecastManager.shared.getForecast(latitude: coordinates?.latitude ?? 0.0, longtitude: coordinates?.longitude ?? 0.0) { forecast in
            DispatchQueue.main.async {
                self.forecastViews.spinner.isHidden = false
            }
            self.weather = forecast
        }
        
        DispatchQueue.main.async {
            //self.forecastViews.setupData(items: self.forecastModel)
            self.forecastViews.maxTemperatureLabel.text = "\(Int(self.forecastModel.last?.tempMax?.rounded() ?? 0.0))°"
            self.forecastViews.minTemperaureLabel.text = "/\(Int(self.forecastModel.last?.tempMin?.rounded() ?? 0.0))°"
            self.forecastViews.weatherImage.image = WeatherImages.shared.weatherImages(id: self.forecastModel.last?.id ?? 803, pod: self.forecastModel.last?.dayOrNight)
            self.forecastViews.humidityLabel.text = "\(self.forecastModel.last?.humidity ?? 0)%"
            self.forecastViews.pressureLabel.text = "\(Int(self.forecastModel.last?.pressure?.rounded() ?? 0.0)) \(UserDefaults.standard.string(forKey: "pressureTitle") ?? "мм.рт.ст.")"
            self.forecastViews.windLabel.text = "\(Int(self.forecastModel.last?.windSpeed?.rounded() ?? 0)) \(UserDefaults.standard.string(forKey: "windTitle") ?? "м/с")"
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.alpha = 0.0
    }
    
    private var weather = [ForecastModel]() {
        didSet {
            DispatchQueue.main.async {
                self.forecastViews.tableView.reloadData()
                self.forecastViews.spinner.isHidden = true
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ForecastVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.cellID, for: indexPath) as! ForecastTableViewCell
        cell.weatherDescription.text = "".configureWeatherDescription(info: weather[indexPath.section].weatherDescription ?? "")
        cell.dayLabel.text = weather[indexPath.section].date?.capitalized
        cell.minTemp.text = "\(Int(weather[indexPath.section].tempMin?.rounded() ?? 0.0))°"
        cell.maxTemp.text = "\(Int(weather[indexPath.section].tempMax?.rounded() ?? 0.0))°"
        cell.weatherImage.image = WeatherImages.shared.weatherImages(id: weather[indexPath.section].id ?? 803, pod: weather[indexPath.section].dayOrNight ?? "d")
        //cell.setupData(items: weather, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
