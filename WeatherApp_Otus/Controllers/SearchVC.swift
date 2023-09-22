//
//  SearchVC.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 08.09.2023.
//

import UIKit
import CoreLocation

class SearchVC: UIViewController {
    
    private let background = Background()
    private let uiElements = SearchScreenViews()
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.cellID)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        return tableView
    }()
    private var locationManager = CLLocationManager()
    private var long = 0.0
    private var lat = 0.0

    private lazy var spinner: CustomLoaderView = {
        let spinner = CustomLoaderView(squareLength: 100)
        spinner.isHidden = true
        return spinner
    }()
    
    private var weatherData = [ForecastModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.spinner.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false // позволяет делать тап по ячейке. Настройка нужна, потому что есть жест
        background.configure(on: view)
        uiElements.configureUIOn(view: view)
        view.addSubview(spinner)
        tableView.dataSource = self
        tableView.delegate = self
        uiElements.searchBar.delegate = self
        view.addSubview(tableView)
        constraintsForTableView()
        uiElements.locationButton.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
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
    }
    
    private func constraintsForTableView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: uiElements.searchBar.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
    
    
    @objc private func locationButtonPressed() {
        DispatchQueue.main.async {
            self.spinner.isHidden = false
            self.spinner.startAnimation(delay: 0.06, replicates: 20)
        }

        CurrentWeatherManager.shared.getWeather(latitude: lat, longtitude: long) { forecastModel in
            self.weatherData.append(forecastModel)
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
        return weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellID, for: indexPath) as! SearchTableViewCell
        cell.cityLabel.text = weatherData[indexPath.section].cityName
        cell.weatherDescriptionLabel.text = weatherData[indexPath.section].description!.prefix(1).uppercased() + weatherData[indexPath.section].description!.lowercased().dropFirst()
        cell.weatherImage.image = WeatherImages.shared.weatherImages(id: weatherData[indexPath.section].id ?? 803, pod: weatherData[indexPath.section].dayOrNight)
        cell.temperatureLabel.text = "\(Int(weatherData[indexPath.section].temp?.rounded() ?? 0))°"
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

        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] (contextualAction, view, completion) in
            self?.weatherData.remove(at: indexPath.section)
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
        for i in weatherData {
            forecastVC.forecastModel.append(ForecastModel(latitude: i.latitude, longitude: i.longitude, description: i.description, id: i.id, dayOrNight: i.dayOrNight, temp: i.temp, tempMin: i.tempMin, tempMax: i.tempMax, pressure: i.pressure, humidity: i.humidity, windSpeed: i.windSpeed, selectedItem: indexPath.section, cityName: i.cityName))
        }
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
        long = locValue.longitude
        lat = locValue.latitude
        manager.stopUpdatingLocation()
    }
}

//MARK: - UISearchBarDelegate
extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchingCity = searchBar.text else { return }
        searchBar.searchTextField.autocorrectionType = .yes
        
        GeocodingManager.shared.search(city: searchingCity) { [weak self] forecastModel in
            self?.weatherData.append(forecastModel)
        }
        searchBar.text = ""
        searchBar.endEditing(true)
    }
}
