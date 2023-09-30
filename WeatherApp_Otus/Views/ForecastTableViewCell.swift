//
//  ForecastTableViewCell.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 21.09.2023.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    static let cellID = "ForecastTableViewCell"
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    let weatherImage: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "cloudy-weather")
        return view
    }()
    
    var weatherDescription: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        //label.font = UIFont(name: "Poppins-SemiBold", size: 12)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        //label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var minTemp: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    var maxTemp: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private var stackView: UIStackView = {
       let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        //view.distribution = .equalSpacing
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = false
        backgroundColor = .clear
        alpha = 0.8
        layer.cornerRadius = 15
        isUserInteractionEnabled = false
        selectionStyle = .none
        
        addSubview(stackView)
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(weatherImage)
        stackView.addArrangedSubview(weatherDescription)
        stackView.addArrangedSubview(minTemp)
        stackView.addArrangedSubview(maxTemp)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            dayLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            dayLabel.widthAnchor.constraint(equalToConstant: 110),
            
            weatherImage.heightAnchor.constraint(equalToConstant: 40),
            weatherImage.widthAnchor.constraint(equalToConstant: 40),
            maxTemp.widthAnchor.constraint(equalToConstant: 30),
            minTemp.widthAnchor.constraint(equalToConstant: 30),
            maxTemp.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }
    
    func setupData(items: [ForecastModel], indexPath: IndexPath) {
        weatherDescription.text = "".configureWeatherDescription(info: items[indexPath.section].weatherDescription ?? "")
        dayLabel.text = items[indexPath.section].date?.capitalized
        minTemp.text = "\(Int(items[indexPath.section].tempMin?.rounded() ?? 0.0))°"
        maxTemp.text = "\(Int(items[indexPath.section].tempMax?.rounded() ?? 0.0))°"
        weatherImage.image = WeatherImages.shared.weatherImages(id: items[indexPath.section].id ?? 803, pod: items[indexPath.section].dayOrNight ?? "d")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
