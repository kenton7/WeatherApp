//
//  File.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 08.09.2023.
//

import UIKit
import Foundation

protocol IWeather {
    var weatherImage: UIImageView { get set }
    var weatherDescription: UILabel { get set }
    var temperatureLabel: UILabel { get set }
    var cityLabel: UILabel { get set }
    var pressureImage: UIImageView { get }
    var pressureLabel: UILabel { get set }
    var pressureName: UILabel { get }
    var humidityImage: UIImageView { get }
    var humidityLabel: UILabel { get set }
    var humidityName: UILabel { get }
    var windImage: UIImageView { get }
    var windLabel: UILabel { get set }
    var windName: UILabel { get }
}

class WeatherViews: UIView, IWeather {
    
    //MARK: -- UI Elements
    
    var weatherImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "cloudy-weather")
        return image
    }()
    
    var weatherDescription: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 70)
        return label
    }()
    
    var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.94
        label.attributedText = NSMutableAttributedString(string: "--",
                                                         attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    var refreshButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.alpha = 0.3
        button.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        button.setImage(UIImage(named: "refresh"), for: .normal)
        button.tintColor = .black
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        return button
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "EEEE, d MMMM yyy"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        df.locale = Locale(identifier: "ru-RU")
        let dateString = df.string(from: date)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.94
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSMutableAttributedString(string: dateString.capitalized,
                                                         attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let pressureImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "pressure")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var pressureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let pressureName: UILabel = {
        let label = UILabel()
        label.text = "Давление"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let humidityImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "insurance 1 (1)")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let humidityName: UILabel = {
        let label = UILabel()
        label.text = "Влажность"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let windImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "insurance 1 (2)")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var windLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let windName: UILabel = {
        let label = UILabel()
        label.text = "Ветер"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: -- Stack Views
    private let detailStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.axis = .horizontal
        view.backgroundColor = UIColor(red: 0.32, green: 0.25, blue: 0.5, alpha: 1)
        view.layer.cornerRadius = 8
        view.alpha = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        return view
    }()
    
    private let weatherDataStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.axis = .vertical
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let visibilityStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.axis = .vertical
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.spacing = 8
        return view
    }()
    
    private let humidityStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.axis = .vertical
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.spacing = 8
        return view
    }()
    
    private let winddStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.axis = .vertical
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.spacing = 8
        return view
    }()
    
    let sevenDaysForecast: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Прогноз"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 1
        return label
    }()
    
    private let todayLabel: UILabel = {
        let label = UILabel()
        label.text = "Сегодня"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 1
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.cellID)
        return collectionView
    }()
    
    lazy var spinner: CustomLoaderView = {
        let spinner = CustomLoaderView(squareLength: 100)
        spinner.isHidden = true
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -- Конфигурация элементов
    func configureViews() {

        addSubview(collectionView)
        addSubview(weatherImage)
        addSubview(weatherDescription)
        addSubview(temperatureLabel)
        addSubview(cityLabel)
        addSubview(refreshButton)
        addSubview(dateLabel)
        addSubview(detailStackView)
        addSubview(weatherDataStackView)
        addSubview(visibilityStackView)
        addSubview(humidityStackView)
        addSubview(winddStackView)
        addSubview(sevenDaysForecast)
        addSubview(todayLabel)
        addSubview(spinner)
        
        weatherDataStackView.addArrangedSubview(weatherDescription)
        weatherDataStackView.addArrangedSubview(weatherImage)
        weatherDataStackView.addArrangedSubview(temperatureLabel)
        weatherDataStackView.addArrangedSubview(dateLabel)
        visibilityStackView.addArrangedSubview(pressureImage)
        visibilityStackView.addArrangedSubview(pressureLabel)
        visibilityStackView.addArrangedSubview(pressureName)
        humidityStackView.addArrangedSubview(humidityImage)
        humidityStackView.addArrangedSubview(humidityLabel)
        humidityStackView.addArrangedSubview(humidityName)
        winddStackView.addArrangedSubview(windImage)
        winddStackView.addArrangedSubview(windLabel)
        winddStackView.addArrangedSubview(windName)
        
        detailStackView.addArrangedSubview(visibilityStackView)
        detailStackView.addArrangedSubview(humidityStackView)
        detailStackView.addArrangedSubview(winddStackView)
        
        cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cityLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        cityLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        refreshButton.centerYAnchor.constraint(equalTo: cityLabel.centerYAnchor).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        refreshButton.widthAnchor.constraint(equalToConstant: 46).isActive = true
        refreshButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true

        weatherDescription.heightAnchor.constraint(equalToConstant: 30).isActive = true
        weatherDataStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        weatherDescription.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5).isActive = true
        
        weatherImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        temperatureLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true

        pressureImage.heightAnchor.constraint(equalToConstant: 24).isActive = true

        humidityStackView.topAnchor.constraint(equalTo: visibilityStackView.topAnchor).isActive = true
        humidityImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        humidityLabel.centerXAnchor.constraint(equalTo: humidityImage.centerXAnchor).isActive = true

        windImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        detailStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        detailStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        detailStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        detailStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        detailStackView.topAnchor.constraint(equalTo: weatherDataStackView.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        
        sevenDaysForecast.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        sevenDaysForecast.topAnchor.constraint(equalTo: detailStackView.bottomAnchor, constant: 10).isActive = true
        
        todayLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        todayLabel.topAnchor.constraint(equalTo: detailStackView.bottomAnchor, constant: 10).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: sevenDaysForecast.bottomAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 110).isActive = true
    }
    
    
    //MARK: - как правильно? тут смущает, что есть взаимодействие view с моделью, что запрещено по MVC
//    func setupData(items: ForecastModel) {
//        weatherImage.image = WeatherImages.shared.weatherImages(id: items.id ?? 803, pod: items.dayOrNight ?? "d")
//        temperatureLabel.text = "\(Int(items.temp?.rounded() ?? 0.0))°"
//        pressureLabel.text = "\(Int(items.pressureFromServer ?? 0)) \(UserDefaults.standard.string(forKey: "pressureTitle") ?? "мм.рт.ст.")"
//        humidityLabel.text = "\(Int(items.humidity ?? 0))%"
//        weatherDescription.text = items.weatherDescriptionFromServer.capitalizingFirstLetter()
//        cityLabel.text = items.cityName
//        windLabel.text = "\(Int(items.windSpeedFromServer ?? 0)) \(UserDefaults.standard.string(forKey: "windTitle") ?? "м/с")"
//    }
    
    //MARK: - или так? Смущает, что много параметров входных, ведь можно же просто передать модель, как в функции выше
    func configureData(image: UIImage, temperature: Int, pressure: Int, humidity: Int, weatherDescription: String, city: String, windSpeed: Int) {
        weatherImage.image = image
        temperatureLabel.text = "\(Int(temperature))°"
        pressureLabel.text = "\(Int(pressure)) \(UserDefaults.standard.string(forKey: "pressureTitle") ?? "мм.рт.ст.")"
        humidityLabel.text = "\(Int(humidity))%"
        self.weatherDescription.text = weatherDescription
        cityLabel.text = city
        windLabel.text = "\(Int(windSpeed)) \(UserDefaults.standard.string(forKey: "windTitle") ?? "м/с")"
    }
}

