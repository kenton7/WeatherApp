//
//  SettingsTableViewCell.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 27.09.2023.
//

import UIKit

enum MeasureType: String, CaseIterable {
    case celcius = "Градусы Цельсия (°C)"
    case farengeight = "Градусы Фаренгейта (°F)"
    case wind = "Ветер"
    case pressure = "Давление"
//    case meterPerSecond = "м/с"
//    case kilometerPerHour = "км/ч"
//    case milesPerHout = "ми/ч"
//    case mmRtSt = "мм.рт.ст."
//    case hektopascal = "гПа"
//    case kilopascal = "кПа"
//    case milibars = "мбар"
//    case inchesRtSt = "д.рт.ст"
}

class SettingsTableViewCell: UITableViewCell {
    
    static let cellID = "SettingsTableViewCell"
    
    let temperatureLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layer.cornerRadius = 15
        backgroundColor = .backgroundColorTabBar
        addSubview(temperatureLabel)
        selectionStyle = .none
        tintColor = .white
        
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            temperatureLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 30),
            temperatureLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
