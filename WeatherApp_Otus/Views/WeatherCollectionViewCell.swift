//
//  WeatherCollectionViewCell.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 09.09.2023.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "WeatherCollectionViewCell"
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .backgroundColorTabBar
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.9
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weatherIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "sun")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundColorTabBar
        view.alpha = 0.8
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        stackView.layer.cornerRadius = 8
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(weatherIcon)
        stackView.addArrangedSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            weatherIcon.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            weatherIcon.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            weatherIcon.heightAnchor.constraint(equalToConstant: 30),
            weatherIcon.widthAnchor.constraint(equalToConstant: 30),
            
            temperatureLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            temperatureLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
        ])
    }
    
    func configureCell(items: [ForecastModel], indexPath: IndexPath) {
        timeLabel.font = UIFont.boldSystemFont(ofSize: 15)
        timeLabel.text = "\(items[indexPath.item].date ?? "")"
        temperatureLabel.text = "\(Int(items[indexPath.row].temp?.rounded() ?? 0))°"
        weatherIcon.image = WeatherImages.shared.weatherImages(id: items[indexPath.row].id ?? 803, pod: items[indexPath.row].dayOrNight)
    }
    
    func configureCell(items: [WeatherModel], indexPath: IndexPath) {
        timeLabel.font = UIFont.boldSystemFont(ofSize: 15)
        //timeLabel.text = "\(items[indexPath.item].date ?? "")"
        timeLabel.text = "\(items[indexPath.item].list?[indexPath.item].dtTxt)"
        //temperatureLabel.text = "\(Int(items[indexPath.row].temp?.rounded() ?? 0))°"
        temperatureLabel.text = "\(Int(items[indexPath.item].list?[indexPath.item].main?.temp?.rounded() ?? 0.0))°"
        weatherIcon.image = WeatherImages.shared.weatherImages(id: items[indexPath.item].list?[indexPath.item].weather?[indexPath.item].id ?? 803, pod: items[indexPath.item].list?[indexPath.item].weather?[indexPath.item].icon)
        //weatherIcon.image = WeatherImages.shared.weatherImages(id: items[indexPath.row].id ?? 803, pod: items[indexPath.row].dayOrNight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
