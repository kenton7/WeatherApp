//
//  SettingsViews.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 27.09.2023.
//

import UIKit

class SettingsViews: UIView {
    
    private let temperatureLabel: UILabel = {
       let label = UILabel()
        label.text = "Единицы измерения"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

//    private let segmentedControl: UISegmentedControl = {
//        let segmentedControl = UISegmentedControl()
//        segmentedControl.setTitle("Градусы Цельсия °C", forSegmentAt: 0)
//        segmentedControl.setTitle("Градусы Фаренгейта °F", forSegmentAt: 1)
//        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
//        segmentedControl.tintColor = .backgroundColorTabBar
//        return segmentedControl
//    }()
    
    func configure(on view: UIView) {
        //view.addSubview(temperatureLabel)
        //view.addSubview(segmentedControl)

    }

}
