//
//  SearchVC.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 08.09.2023.
//

import UIKit
import CoreLocation
import RealmSwift

final class SearchVC: UIViewController {
    
    private let uiElements = SearchScreenViews()
    private var locationManager = CLLocationManager()
    
    private var weatherData = [ForecastModel]() {
        didSet {
            DispatchQueue.main.async {
                self.uiElements.tableView.reloadData()
                self.uiElements.spinner.isHidden = true
            }
        }
    }
    
    private let realm = try! Realm()
    private var forecastRealm: Results<ForecastRealm>?
    private var coordinates: Coordinates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false // позволяет делать тап по ячейке. Настройка нужна, потому что есть жест
        uiElements.configureUIOn(view: view)
        uiElements.tableView.dataSource = self
        uiElements.tableView.delegate = self
        uiElements.searchBar.delegate = self
        uiElements.locationButton.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        forecastRealm = realm.objects(ForecastRealm.self)
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.alpha = 1.0
        uiElements.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.alpha = 0.0
    }
    
    @objc private func locationButtonPressed() {
        DispatchQueue.main.async {
            self.uiElements.spinner.isHidden = false
            self.uiElements.spinner.startAnimation(delay: 0.06, replicates: 20)
        }
        
        CurrentWeatherManager.shared.getWeather(latitude: coordinates?.latitude ?? 0.0, longtitude: coordinates?.longitude ?? 0.0) { [weak self] forecastModel in
            guard let self else { return }
            
            DispatchQueue.main.async {
                try! self.realm.write {
                    self.realm.add(ForecastRealm(cityName: forecastModel.cityName ?? "" ,
                                                 dayOrNight: forecastModel.dayOrNight ?? "d" ,
                                                 weatherDescription: forecastModel.weatherDescription ?? "" ,
                                                 id: forecastModel.id ?? 803,
                                                 temp: forecastModel.temp ?? 0.0,
                                                 latitude: forecastModel.latitude ?? 0.0,
                                                 longitude: forecastModel.longitude ?? 0.0,
                                                 tempMin: forecastModel.tempMin ?? 0.0,
                                                 tempMax: forecastModel.tempMax ?? 0.0,
                                                 pressure: forecastModel.pressure ?? 0,
                                                 humidity: forecastModel.humidity ?? 0,
                                                 windSpeed: forecastModel.windSpeed ?? 0.0,
                                                 selectedItem: forecastModel.selectedItem ?? 0,
                                                 date: forecastModel.date ?? ""))
                    self.uiElements.tableView.reloadData()
                    self.uiElements.spinner.isHidden = true
                }
            }
        }
    }
    
    //Убираем клаву при тапе на экран
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return forecastRealm?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellID, for: indexPath) as! SearchTableViewCell
        
        GeocodingManager.shared.search(city: forecastRealm?[indexPath.section].cityName ?? "") { [weak self] forecast in
            guard let self = self else { return }
            //Обновляем данные в ячейках (в бд Realm) новыми данными из API
            DispatchQueue.main.async {
                try! self.realm.write {
                    self.forecastRealm?[indexPath.section].temp = forecast.temp?.rounded() ?? 0.0
                    self.forecastRealm?[indexPath.section].weatherDescription = forecast.weatherDescription ?? ""
                    self.forecastRealm?[indexPath.section].id = forecast.id ?? 803
                    self.forecastRealm?[indexPath.section].dayOrNight = forecast.dayOrNight ?? "d"
                    self.forecastRealm?[indexPath.section].humidity = forecast.humidity ?? 0
                    self.forecastRealm?[indexPath.section].latitude = forecast.latitude ?? 0.0
                    self.forecastRealm?[indexPath.section].longitude = forecast.longitude ?? 0.0
                    self.forecastRealm?[indexPath.section].pressure = forecast.pressure ?? 0.0
                    self.forecastRealm?[indexPath.section].selectedItem = forecast.selectedItem ?? 0
                    self.forecastRealm?[indexPath.section].temp = forecast.temp ?? 0.0
                    self.forecastRealm?[indexPath.section].tempMax = forecast.tempMax ?? 0.0
                    self.forecastRealm?[indexPath.section].tempMin = forecast.tempMin ?? 0.0
                    self.forecastRealm?[indexPath.section].weatherDescription = forecast.weatherDescription ?? ""
                    self.forecastRealm?[indexPath.section].windSpeed = forecast.windSpeed ?? 0.0
                    self.forecastRealm?[indexPath.section].date = forecast.date ?? ""
                }
                cell.setupData(items: self.forecastRealm, indexPath: indexPath)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.isUserInteractionEnabled = false
        header.backgroundColor = .clear
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let header = UIView()
        header.isUserInteractionEnabled = false
        header.backgroundColor = .clear
        header.clipsToBounds = false
        return header
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Удаление элемента
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] (contextualAction, _, completion) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                try! self.realm.write {
                    self.realm.delete(self.forecastRealm![indexPath.section])
                }
                self.uiElements.tableView.reloadData()
            }
            completion(true)
        }
        
        //кастомный вид удаления
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17.0, weight: .bold, scale: .large)
        delete.image = UIImage(systemName: "trash", withConfiguration: largeConfig)?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.systemRed)
        delete.backgroundColor = .red
        delete.title = "Удалить"
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    //при отказе удалять, возвращаем ячейке закругленные углы
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? SearchTableViewCell {
            cell.layer.cornerRadius = 15
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let forecastVC = ForecastVC()
        if let transferData = forecastRealm?[indexPath.section] {
            forecastVC.coordinates = Coordinates(latitude: transferData.latitude, longitude: transferData.longitude)
            
            forecastVC.forecastModel.append(ForecastModel(
                latitude: transferData.latitude,
                longitude: transferData.longitude,
                weatherDescription: transferData.weatherDescription,
                id: transferData.id,
                dayOrNight: transferData.dayOrNight,
                temp: transferData.temp,
                tempMin: transferData.tempMin,
                tempMax: transferData.tempMax,
                pressure: transferData.pressure,
                humidity: transferData.humidity,
                windSpeed: transferData.windSpeed,
                selectedItem: indexPath.section,
                cityName: transferData.cityName,
                date: transferData.date))
        }
        
        forecastVC.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(forecastVC, animated: true)
    }
    
}

//MARK: - CLLocationManagerDelegate
extension SearchVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        coordinates = Coordinates(latitude: locValue.latitude, longitude: locValue.longitude)
        manager.stopUpdatingLocation()
    }
}

//MARK: - UISearchBarDelegate
extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchingCity = searchBar.text else { return }
        searchBar.searchTextField.autocorrectionType = .yes
        
        GeocodingManager.shared.search(city: searchingCity) { [weak self] forecastModel in
            guard let self = self else { return }
            
            //Проверяем добавил ли юзер такой город или нет
            DispatchQueue.main.async {
                for data in self.forecastRealm! {
                    if data.cityName == searchingCity {
                        let alert = UIAlertController(title: "Ошибка", message: "Такой город уже добавлен", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
                        self.present(alert, animated: true)
                        return
                    }
                }
                
                try! self.realm.write {
                    self.realm.add(ForecastRealm(cityName: forecastModel.cityName ?? "",
                                                 dayOrNight: forecastModel.dayOrNight ?? "d",
                                                 weatherDescription: forecastModel.weatherDescription ?? "",
                                                 id: forecastModel.id ?? 803,
                                                 temp: forecastModel.temp ?? 0.0,
                                                 latitude: forecastModel.latitude ?? 0.0,
                                                 longitude: forecastModel.longitude ?? 0.0,
                                                 tempMin: forecastModel.tempMin ?? 0.0,
                                                 tempMax: forecastModel.tempMax ?? 0.0,
                                                 pressure: forecastModel.pressure ?? 0.0,
                                                 humidity: forecastModel.humidity ?? 0,
                                                 windSpeed: forecastModel.windSpeed ?? 0.0,
                                                 selectedItem: forecastModel.selectedItem ?? 0,
                                                 date: forecastModel.date ?? ""))
                    self.uiElements.tableView.reloadData()
                    self.uiElements.spinner.isHidden = true
                }
            }
        }
        searchBar.text = ""
        searchBar.endEditing(true)
    }
}
