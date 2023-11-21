//
//  SettingsViews.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 27.09.2023.
//

import UIKit

class SettingsViews: WeatherViews {

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.cellID)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureViews() {
        addSubview(tableView)
        backgroundColor = UIColor(red: 0.11, green: 0.16, blue: 0.22, alpha: 1)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}
