//
//  SearchTableViewCell.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 20.09.2023.
//

import UIKit
import RealmSwift

class SearchTableViewCell: UITableViewCell {
    
    static let cellID = "SearchTableViewCell"
    
    let weatherImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "cloudy-weather")
        return image
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "--°"
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    
    private let stackView: UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = false
        backgroundColor = UIColor(red: 0.322, green: 0.239, blue: 0.498, alpha: 1)
        alpha = 0.8
        layer.cornerRadius = 15
        isUserInteractionEnabled = true
        selectionStyle = .none
        
        
        addSubview(stackView)
        addSubview(weatherImage)
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(weatherDescriptionLabel)
        addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            weatherImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            weatherImage.heightAnchor.constraint(equalToConstant: 90),
            weatherImage.widthAnchor.constraint(equalToConstant: 110),
            weatherImage.centerYAnchor.constraint(equalTo: centerYAnchor),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            
            cityLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            
            temperatureLabel.trailingAnchor.constraint(equalTo: weatherImage.leadingAnchor, constant: -5),
            temperatureLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
//    func setupData(items: Results<ForecastRealm>?, indexPath: IndexPath) {
//        guard let items = items else { return }
//        cityLabel.text = items[indexPath.section].cityName
//        weatherDescriptionLabel.text = items[indexPath.section].weatherDescription.prefix(1).uppercased() + "\(items[indexPath.section].weatherDescription.lowercased().dropFirst())"
////        weatherDescriptionLabel.text = "".configureWeatherDescription(info: items[indexPath.section].weatherDescription.prefix(1).uppercased() +
////                                                                      "\(items[indexPath.section].weatherDescription.lowercased().dropFirst())")
//        weatherImage.image = WeatherImages.shared.weatherImages(id: items[indexPath.section].id, pod: items[indexPath.section].dayOrNight)
//        temperatureLabel.text = "\(Int(items[indexPath.section].temp.rounded()))°"
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
