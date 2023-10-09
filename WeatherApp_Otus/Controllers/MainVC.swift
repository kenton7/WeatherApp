//
//  ViewController.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 08.09.2023.
//

import UIKit
import CoreLocation

final class MainVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let weatherUIElements = MainWeatherViews()
    private var locationManager = CLLocationManager()
    
    private var weatherModel = [ForecastModel]() {
        didSet {
            DispatchQueue.main.async {
                self.weatherUIElements.collectionView.reloadData()
                self.weatherUIElements.spinner.isHidden = true
            }
        }
    }
    
    private var coordinates: Coordinates?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherUIElements.collectionView.dataSource = self
        weatherUIElements.collectionView.delegate = self
        //weatherUIElements.animateBackground(image: UIImage(named: "BackgroundImage")!, on: view)
        //animateBackground(image: UIImage(named: "BackgroundImage")!, on: view)
        //view.animateBackground(image: UIImage(named: "nightSky")!, on: view)
        weatherUIElements.configureWeatherImage(on: self.view)
        
        
        weatherUIElements.refreshButton.addTarget(self, action: #selector(refreshButtonPressed), for: .touchUpInside)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCurrentWeather()
        getForecast()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    //MARK: -- Добавляем действие на кнопки
    @objc private func refreshButtonPressed() {
        DispatchQueue.main.async {
            self.weatherUIElements.spinner.isHidden = false
            self.weatherUIElements.spinner.startAnimation(delay: 0.0, replicates: 20)
        }
        getCurrentWeather()
        getForecast()
    }
    
    private func getForecast() {
        ForecastManager.shared.getForecastWithCoordinates(latitude: coordinates?.latitude ?? 0.0, longtitude: coordinates?.longitude ?? 0.0, completion: { [weak self] forecast in
            guard let self else { return }
            self.weatherModel = forecast
        })
    }
    
    private func getCurrentWeather() {
        CurrentWeatherManager.shared.getWeather(latitude: coordinates?.latitude ?? 0.0, longtitude: coordinates?.longitude ?? 0.0) { [weak self] weatherModel in
            DispatchQueue.main.async {
                //self?.weatherUIElements.setupData(items: weatherModel)
                self?.weatherUIElements.configureData(image: WeatherImages.shared.weatherImages(id: weatherModel.id ?? 803, pod: weatherModel.dayOrNight),
                                                      temperature: Int(weatherModel.temp ?? 0.0),
                                                      pressure: Int(weatherModel.pressure ?? 0.0),
                                                      humidity: weatherModel.humidity ?? 0,
                                                      weatherDescription: (weatherModel.weatherDescription?.prefix(1).uppercased() ?? "") + ((weatherModel.weatherDescription?.lowercased().dropFirst() ?? "")),
                                                      city: weatherModel.cityName ?? "",
                                                      windSpeed: Int(weatherModel.windSpeed ?? 0.0))
                
                if weatherModel.dayOrNight == "n" {
                    self?.view.animateBackground(image: UIImage(named: "nightSky")!, on: self!.view)
                } else {
                self?.view.animateBackground(image: UIImage(named: "BackgroundImage")!, on: self!.view)
                }
            
                self?.weatherUIElements.spinner.isHidden = true
                self?.weatherUIElements.spinner.stopAnimation()
                self?.weatherUIElements.collectionView.reloadData()
            }
        }
    }
    
    //MARK: -- CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.cellID, for: indexPath) as! WeatherCollectionViewCell
        cell.configureCell(items: weatherModel, indexPath: indexPath)
        if indexPath.row == 0 {
            cell.timeLabel.text = "Сейчас"
            //cell.timeLabel.text = "\(calendar.component(.hour, from: Date())):00"
            cell.temperatureLabel.text = weatherUIElements.temperatureLabel.text
            cell.weatherIcon.image = weatherUIElements.weatherImage.image
        } else {
            cell.timeLabel.text = weatherModel[indexPath.row].date
            cell.temperatureLabel.text = "\(Int(weatherModel[indexPath.row].temp?.rounded() ?? 0.0))°"
            cell.weatherIcon.image = WeatherImages.shared.weatherImages(id: weatherModel[indexPath.row].id ?? 803, pod: weatherModel[indexPath.row].dayOrNight)
            //cell.configureCell(items: weatherModel, indexPath: indexPath)
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
                self.weatherUIElements.spinner.isHidden = false
                self.weatherUIElements.spinner.startAnimation(delay: 0.06, replicates: 20)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        coordinates = Coordinates(latitude: locValue.latitude, longitude: locValue.longitude)
        manager.stopUpdatingLocation()
    }
}


