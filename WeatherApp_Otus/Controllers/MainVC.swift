//
//  ViewController.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 08.09.2023.
//

import UIKit
import CoreLocation

final class MainVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let weatherUIElements = MainScreenViews()
    private let currentWeatherService = CurrentWeatherService()
    private var locationManager = CLLocationManager()
    private let storage = UserDefaults.standard
    
    private var forecast = [ForecastModel]() {
        didSet {
            DispatchQueue.main.async {
                self.weatherUIElements.collectionView.reloadData()
                self.weatherUIElements.spinner.isHidden = true
            }
        }
    }
    
    private var forecastNew: WeatherModel?
    
    private var currentWeather: CurrentWeather?
    private var forecastArray = Array<List>.SubSequence()
    
    private var coordinates: Coordinates?
    
    override func loadView() {
        super.loadView()
        view = weatherUIElements
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            }
        }
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        weatherUIElements.collectionView.dataSource = self
        weatherUIElements.collectionView.delegate = self
        weatherUIElements.refreshButton.addTarget(self, action: #selector(refreshButtonPressed), for: .touchUpInside)
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //
    //        sleep(UInt32(0.5))
    //        //getCurrentWeather()
    //        //getForecast()
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCurrentWeather()
        //getForecastNew()
        getForecast()
    }
    
    private func getForecastNew() {
        
        guard let longitude = coordinates?.longitude, let latitude = coordinates?.latitude else { return }
                
        currentWeatherService.getForecast(longitude: longitude, latitide: latitude, units: UserDefaults.standard.string(forKey: "units") ?? "metric", lang: Language.ru) { result in
            switch result {
            case .success(let forecast):
                self.forecastNew = forecast
                self.forecastArray = (forecast.list?.prefix(8))!
                //self.weatherUIElements.collectionView.reloadData()
                self.weatherUIElements.spinner.isHidden = true
                print(self.forecastNew)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    private func getCurrentWeather() {
        
        guard let longitude = coordinates?.longitude, let latitude = coordinates?.latitude else { return }
        
        currentWeatherService.getCurrentWeather(longitute: longitude, latitude: latitude, units: UserDefaults.standard.string(forKey: "units") ?? "metric", language: Language.ru) { result in
            switch result {
            case .success(let weather):
                //self.weatherModel = [weather]
                self.currentWeather = weather
                guard let currentWeather = self.currentWeather else { return }

                self.weatherUIElements.configureData(image: WeatherImages.shared.weatherImages(id: currentWeather.weather?.first?.id ?? 803,
                                                                                               pod: String(currentWeather.weather?.first?.icon?.last ?? "d")),
                                                     temperature: Int(currentWeather.main?.temp ?? 0.0.rounded()),
                                                     pressure: CalculateMeasurements.shared.calculatePressure(measurementIndex: UserDefaults.standard.integer(forKey: "pressureIndex"), value: currentWeather.main?.pressure ?? 0),
                                                     humidity: currentWeather.main?.humidity ?? 0,
                                                     weatherDescription: currentWeather.weather?.first?.description?.capitalizingFirstLetter() ?? "",
                                                     city: currentWeather.name ?? "",
                                                     windSpeed: CalculateMeasurements.shared.calculateWindSpeed(measurementIndex: UserDefaults.standard.integer(forKey: "windIndex"), value: currentWeather.wind?.speed ?? 0.0))
                
                switch currentWeather.weather?.first?.icon?.last {
                case "n":
                    if let nightImage = UIImage(named: "nightSky") {
                        self.view.animateBackground(image: nightImage, on: self.view)
                    } else {
                        print("There's no image with such name")
                    }
                case "d":
                    if let dayImage = UIImage(named: "BackgroundImage") {
                        self.view.animateBackground(image: dayImage, on: self.view)
                    } else {
                        print("There's no image with such name")
                    }
                default:
                    break
                }
                
                self.weatherUIElements.spinner.isHidden = true
                self.weatherUIElements.spinner.stopAnimation()
                self.weatherUIElements.collectionView.reloadData()
                //-----
                //                self.weatherUIElements.configureData(image: WeatherImages.shared.weatherImages(id: weather.id ?? 893, pod: weather.dayOrNight), temperature: Int(weather.temp ?? 0.0), pressure: CalculateMeasurements.shared.calculatePressure(measurementIndex: UserDefaults.standard.integer(forKey: "pressureIndex"), value: weather.pressureFromServer ?? 0), humidity: weather.humidity ?? 0, weatherDescription: weather.weatherDescriptionFromServer, city: weather.cityName ?? "", windSpeed: CalculateMeasurements.shared.calculateWindSpeed(measurementIndex: UserDefaults.standard.integer(forKey: "winIndex"), value: weather.windSpeedFromServer ?? 0.0))
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    //MARK: -- Добавляем действие на кнопки
    @objc private func refreshButtonPressed() {
        DispatchQueue.main.async {
            self.weatherUIElements.spinner.isHidden = false
            self.weatherUIElements.spinner.startAnimation(delay: 0.0, replicates: 20)
        }
        getForecast()
        getCurrentWeather()
    }
    
    private func getForecast() {
        ForecastManager.shared.getForecastWithCoordinates(latitude: coordinates?.latitude ?? 0.0, longtitude: coordinates?.longitude ?? 0.0, completion: { [weak self] forecast in
            guard let self else { return }
            self.forecast = forecast
        })
    }
    
    //MARK: -- CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.cellID, for: indexPath) as! WeatherCollectionViewCell
        
        print(forecast.count)

        cell.configureCell(items: forecast, indexPath: indexPath)
        if indexPath.row == 0 {
            cell.timeLabel.text = "Сейчас"
            cell.temperatureLabel.text = "\(Int(forecast[indexPath.item].temp?.rounded() ?? 0.0))"
            //cell.timeLabel.text = "\(calendar.component(.hour, from: Date())):00"
            //cell.temperatureLabel.text = weatherUIElements.temperatureLabel.text
            //cell.weatherIcon.image = weatherUIElements.weatherImage.image
        } else {
            //cell.timeLabel.text = forecast[indexPath.row].date
            cell.timeLabel.text = forecast[indexPath.item].date
            cell.temperatureLabel.text = "\(Int(forecast[indexPath.item].temp?.rounded() ?? 0.0))°"
            //cell.temperatureLabel.text = "\(Int(forecast[indexPath.row].temp?.rounded() ?? 0.0))°"
            cell.weatherIcon.image = WeatherImages.shared.weatherImages(id: forecast[indexPath.row].id ?? 803, pod: forecast[indexPath.row].dayOrNight)
            //cell.configureCell(items: weatherModel, indexPath: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast.count
        //return 8
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
                self.getForecast()
                self.getCurrentWeather()
                //self.getForecastNew()
                self.weatherUIElements.spinner.isHidden = false
                self.weatherUIElements.spinner.startAnimation(delay: 0.06, replicates: 20)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        coordinates = Coordinates(latitude: locValue.latitude, longitude: locValue.longitude)
        let encodedCoordinates = try! JSONEncoder().encode(coordinates)
        storage.setValue(encodedCoordinates, forKey: "coordinates")
        getCurrentWeather()
        //getForecastNew()
        getForecast()
        manager.stopUpdatingLocation()
    }
}


