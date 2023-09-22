//
//  ForecastViews.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 21.09.2023.
//

import UIKit

class ForecastViews {
    
    let weatherView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.322, green: 0.239, blue: 0.498, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    let weatherStackView: UIStackView = {
       let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.backgroundColor = UIColor(red: 0.322, green: 0.239, blue: 0.498, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    let weatherImage: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "cloudy-weather")
        return view
    }()
    
    let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "20°"
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    let minTemperaureLabel: UILabel = {
        let label = UILabel()
        label.text = "/ --°"
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    
    let pressureImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "pressure")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let pressureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let pressureName: UILabel = {
        let label = UILabel()
        label.text = "Давление"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let humidityImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "insurance 1 (1)")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let humidityName: UILabel = {
        let label = UILabel()
        label.text = "Влажность"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let windImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "insurance 1 (2)")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let windLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let windName: UILabel = {
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
    let detailStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.axis = .horizontal
        //view.backgroundColor = UIColor(red: 0.32, green: 0.25, blue: 0.5, alpha: 1)
        view.layer.cornerRadius = 8
        view.alpha = 0.8
        return view
    }()
    
    let pressureStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.axis = .vertical
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.spacing = 8
        return view
    }()
    
    let humidityStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.axis = .vertical
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.spacing = 8
        return view
    }()
    
    let winddStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.axis = .vertical
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.spacing = 8
        return view
    }()
    
    
    func configure(on view: UIView) {
        view.addSubview(weatherView)
        view.addSubview(weatherImage)
        view.addSubview(maxTemperatureLabel)
        view.addSubview(minTemperaureLabel)
        view.addSubview(detailStackView)
        
        detailStackView.addArrangedSubview(pressureStackView)
        detailStackView.addArrangedSubview(humidityStackView)
        detailStackView.addArrangedSubview(winddStackView)
        pressureStackView.addArrangedSubview(pressureImage)
        pressureStackView.addArrangedSubview(pressureLabel)
        pressureStackView.addArrangedSubview(pressureName)
        humidityStackView.addArrangedSubview(humidityImage)
        humidityStackView.addArrangedSubview(humidityLabel)
        humidityStackView.addArrangedSubview(humidityName)
        winddStackView.addArrangedSubview(windImage)
        winddStackView.addArrangedSubview(windLabel)
        winddStackView.addArrangedSubview(windName)
        
        NSLayoutConstraint.activate([
            weatherView.heightAnchor.constraint(equalToConstant: 250),
            weatherView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            weatherView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            weatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            weatherImage.leadingAnchor.constraint(equalTo: weatherView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            weatherImage.topAnchor.constraint(equalTo: weatherView.safeAreaLayoutGuide.topAnchor, constant: 10),
            weatherImage.heightAnchor.constraint(equalToConstant: 120),
            weatherImage.widthAnchor.constraint(equalToConstant: 120),
            
            maxTemperatureLabel.leadingAnchor.constraint(equalTo: weatherImage.safeAreaLayoutGuide.trailingAnchor, constant: 30),
            maxTemperatureLabel.topAnchor.constraint(equalTo: weatherView.safeAreaLayoutGuide.topAnchor, constant: 10),
            minTemperaureLabel.leadingAnchor.constraint(equalTo: maxTemperatureLabel.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            minTemperaureLabel.topAnchor.constraint(equalTo: weatherView.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            humidityStackView.topAnchor.constraint(equalTo: pressureStackView.topAnchor),
            humidityImage.heightAnchor.constraint(equalToConstant: 24),
            humidityLabel.centerXAnchor.constraint(equalTo: humidityImage.centerXAnchor),
            windImage.heightAnchor.constraint(equalToConstant: 24),
            pressureImage.heightAnchor.constraint(equalToConstant: 24),
            
            detailStackView.centerXAnchor.constraint(equalTo: weatherView.centerXAnchor),
            detailStackView.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 5),
            detailStackView.widthAnchor.constraint(equalTo: weatherView.widthAnchor, multiplier: 0.9),
            detailStackView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
}