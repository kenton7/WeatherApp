//
//  ForecastViews.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 21.09.2023.
//

import UIKit

class ForecastViews: WeatherViews {
    
    let weatherView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.322, green: 0.239, blue: 0.498, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let weatherStackView: UIStackView = {
       let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.backgroundColor = UIColor(red: 0.322, green: 0.239, blue: 0.498, alpha: 1)
        view.layer.cornerRadius = 15
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
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.cellID)
        return tableView
    }()
    
    //MARK: -- Stack Views
    private let detailStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.axis = .horizontal
        view.layer.cornerRadius = 8
        view.alpha = 0.8
        return view
    }()
    
    private let pressureStackView: UIStackView = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        
    }
    override func configureViews() {
        backgroundColor = UIColor(red: 0.28, green: 0.19, blue: 0.62, alpha: 1)
        addSubview(tableView)
        addSubview(weatherView)
        addSubview(weatherImage)
        addSubview(maxTemperatureLabel)
        addSubview(minTemperaureLabel)
        addSubview(detailStackView)
        addSubview(spinner)
        
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
            weatherView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            weatherView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            weatherView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            
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
            
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: weatherView.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
//    func setupData(items: [ForecastModel]) {
//        maxTemperatureLabel.text = "\(Int(items.last?.tempMax?.rounded() ?? 0.0))°"
//        minTemperaureLabel.text = "/\(Int(items.last?.tempMin?.rounded() ?? 0.0))°"
//        weatherImage.image = WeatherImages.shared.weatherImages(id: items.last?.id ?? 803, pod: items.last?.dayOrNight)
//        humidityLabel.text = "\(items.last?.humidity ?? 0)%"
//        pressureLabel.text = "\(Int(items.last?.pressureFromServer ?? 0)) \(UserDefaults.standard.string(forKey: "pressureTitle") ?? "мм.рт.ст.")"
//        windLabel.text = "\(Int(items.last?.pressureFromServer ?? 0)) \(UserDefaults.standard.string(forKey: "windTitle") ?? "м/с")"
//    }
    
}
