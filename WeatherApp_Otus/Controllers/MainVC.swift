//
//  ViewController.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 08.09.2023.
//

import UIKit
import CoreLocation

class MainVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let weatherUIElements = MainWeatherViews()
    private let backView = Background()
    private var locationManager = CLLocationManager()
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.cellID)
        return collectionView
    }()
    
    var long = 0.0
    var lat = 0.0
    private lazy var spinner: CustomLoaderView = {
        let spinner = CustomLoaderView(squareLength: 100)
        spinner.isHidden = true
        return spinner
    }()
    
    private var weatherModel = [ForecastModel]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.spinner.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
        collectionView.dataSource = self
        collectionView.delegate = self
        backView.configure(on: self.view)
        weatherUIElements.configureWeatherImage(on: self.view)
        view.addSubview(collectionView)
        view.addSubview(spinner)
        
        weatherUIElements.refreshButton.addTarget(self, action: #selector(refreshButtonPressed), for: .touchUpInside)
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        constarints()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCurrentWeather()
        getForecast()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func constarints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: weatherUIElements.sevenDaysForecast.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 110),
        ])
    }
    
    @objc func showOfflineDeviceUI(notification: Notification) {
        if NetworkMonitor.shared.isConnected {
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Вы не подключены к интернету", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    //MARK: -- Добавляем действие на кнопки
    @objc private func refreshButtonPressed() {
        DispatchQueue.main.async {
            self.spinner.isHidden = false
            self.spinner.startAnimation(delay: 0.06, replicates: 20)
        }
        getCurrentWeather()
        getForecast()
    }
    
    private func getForecast() {
        ForecastManager.shared.getForecastWithCoordinates(latitude: lat, longtitude: long, completion: { [weak self] forecast in
            guard let self else { return }
            self.weatherModel = forecast
        })
    }
    
    private func getCurrentWeather() {
        let calendar = Calendar.current
        
        CurrentWeatherManager.shared.getWeather(latitude: lat, longtitude: long) { [weak self] weatherModel in

            DispatchQueue.main.async {
                self?.weatherUIElements.weatherImage.image = WeatherImages.shared.weatherImages(id: weatherModel.id ?? 803 , pod: calendar.component(.hour, from: Date()) >= 20 ? "n" : "d")
                self?.weatherUIElements.temperatureLabel.text = "\(Int(weatherModel.temp?.rounded() ?? 0))°"
                self?.weatherUIElements.pressureLabel.text = "\(Int((weatherModel.pressure ?? 0) * 0.750064)) мм рт.ст."
                self?.weatherUIElements.humidityLabel.text = "\(Int(weatherModel.humidity ?? 0))%"
                self?.weatherUIElements.windLabel.text = "\(Int(weatherModel.windSpeed?.rounded() ?? 0)) м/с"
                self?.weatherUIElements.weatherDescription.text = weatherModel.description!.prefix(1).uppercased() + (weatherModel.description?.lowercased().dropFirst())!
                self?.weatherUIElements.cityLabel.text = weatherModel.cityName
                self?.spinner.isHidden = true
                self?.spinner.stopAnimation()
                self?.collectionView.reloadData()
            }
        }
    }
    
    //MARK: -- CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.cellID, for: indexPath) as! WeatherCollectionViewCell
        let calendar = Calendar.current
        if indexPath.row == 0 {
            cell.timeLabel.text = "\(calendar.component(.hour, from: Date())):00"
            cell.temperatureLabel.text = weatherUIElements.temperatureLabel.text
            cell.weatherIcon.image = weatherUIElements.weatherImage.image
        } else {
            cell.timeLabel.font = UIFont.boldSystemFont(ofSize: 15)
            cell.timeLabel.text = "\(weatherModel[indexPath.row].date ?? "")"
            cell.temperatureLabel.text = "\(Int(weatherModel[indexPath.row].temp?.rounded() ?? 0))°"
            cell.weatherIcon.image = WeatherImages.shared.weatherImages(id: weatherModel[indexPath.row].id ?? 803, pod: weatherModel[indexPath.row].dayOrNight)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 100)
    }
}

//MARK: - CLLocationManagerDelegate
extension MainVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
            
            DispatchQueue.main.async {
                self.spinner.isHidden = false
                self.spinner.startAnimation(delay: 0.06, replicates: 20)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        long = locValue.longitude
        lat = locValue.latitude
        manager.stopUpdatingLocation()
    }
}

