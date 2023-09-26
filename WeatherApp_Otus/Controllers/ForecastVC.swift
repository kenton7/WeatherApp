//
//  ForecastVC.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 21.09.2023.
//

import UIKit

final class ForecastVC: UIViewController {
    
    private let forecastViews = ForecastViews()
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.cellID)
        return tableView
    }()
    var forecastModel = [ForecastModel]()
    private var searchVC = SearchVC()
    var lat = 0.0
    var long = 0.0
    
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
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        constraintsForTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.alpha = 1.0
        updateViews()
        
//        ForecastManager.shared.getForecastWithCoordinates(latitude: <#T##Double#>, longtitude: <#T##Double#>) { [weak self] forecast in
//            guard let self = self else { return }
//            
//            forecast.
//        }
    }
    
    private var weather = [ForecastModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ForecastManager.shared.getForecast(latitude: lat, longtitude: long) { forecast in
            self.weather = forecast
            //print(forecast.)
        }
    }
    
//    private func getForecast() {
//        for i in forecastModel {
//            guard let lat = i.latitude, let long = i.longitude else { return }
//            ForecastManager.shared.getForecast(latitude: lat, longtitude: long) { [weak self] forecast in
//                guard let self else { return }
//                self.forecastModel = forecast
//            }
//        }
//        
//        print("forecastModel \(forecastModel)")
//    }
    
    private func updateViews() {
        for _ in forecastModel {
            DispatchQueue.main.async {
                self.forecastViews.maxTemperatureLabel.text = "\(Int(self.forecastModel.last?.tempMax?.rounded() ?? 0.0))°"
                self.forecastViews.minTemperaureLabel.text = " / \(Int(self.forecastModel.last?.tempMin?.rounded() ?? 0.0))°"
                self.forecastViews.weatherImage.image = WeatherImages.shared.weatherImages(id: self.forecastModel.last?.id ?? 803, pod: self.forecastModel.last?.dayOrNight)
                self.forecastViews.humidityLabel.text = "\(self.forecastModel.last?.humidity ?? 0)%"
                self.forecastViews.pressureLabel.text = "\(Int((self.forecastModel.last?.pressure?.rounded() ?? 0) * 0.750064)) мм.рт.ст."
                self.forecastViews.windLabel.text = "\(Int(self.forecastModel.last?.windSpeed?.rounded() ?? 0)) м/с"
                //self.forecastViews.maxTemperatureLabel.text = "\(Int(self.forecastModel[data.selectedItem ?? 0].tempMax?.rounded() ?? 0.0))°"
//                self.forecastViews.minTemperaureLabel.text = " / \(Int(self.forecastModel[data.selectedItem ?? 0].tempMin?.rounded() ?? 0.0))°"
//                self.forecastViews.weatherImage.image = WeatherImages.shared.weatherImages(id: self.forecastModel[data.selectedItem ?? 0].id ?? 803, pod: self.forecastModel[data.selectedItem ?? 0].dayOrNight)
//                self.forecastViews.humidityLabel.text = "\(self.forecastModel[data.selectedItem ?? 0].humidity ?? 0)%"
//                self.forecastViews.pressureLabel.text = "\(Int((self.forecastModel[data.selectedItem ?? 0].pressure?.rounded() ?? 0) * 0.750064)) мм.рт.ст."
//                self.forecastViews.windLabel.text = "\(Int(self.forecastModel[data.selectedItem ?? 0].windSpeed?.rounded() ?? 0)) м/с"
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.alpha = 0.0
    }
    
    
    private func constraintsForTableView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: forecastViews.weatherView.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
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
        cell.dayLabel.text = weather[indexPath.section].date?.capitalized
        cell.minTemp.text = "\(Int(weather[indexPath.section].tempMin?.rounded() ?? 0.0))°"
        cell.maxTemp.text = "\(Int(weather[indexPath.section].tempMax?.rounded() ?? 0.0))°"
        cell.weatherImage.image = WeatherImages.shared.weatherImages(id: weather[indexPath.section].id ?? 803, pod: weather[indexPath.section].dayOrNight ?? "d")
        //cell.weatherDescription.text = weather[indexPath.section].description?.prefix(1).uppercased() + (weather[indexPath.section].description?.lowercased().dropFirst())!
        let separatedDescription = weather[indexPath.section].weatherDescription?.components(separatedBy: " ")
        let finalDescription = "\(separatedDescription?[0].capitalized ?? "")\n\(separatedDescription?.last ?? "")"
        if separatedDescription!.count >= 2 {
            cell.weatherDescription.text = finalDescription
        } else {
            cell.weatherDescription.text = weather[indexPath.section].weatherDescription!.prefix(1).uppercased() + (weather[indexPath.section].weatherDescription?.lowercased().dropFirst())!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
