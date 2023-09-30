//
//  SearchScreenViews.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 20.09.2023.
//

import UIKit

class SearchScreenViews {
    
    //MARK: - Views
    
    private let background = Background()
    
    let locationButton: UIButton = {
       let button = UIButton()
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.layer.backgroundColor = UIColor(red: 0.322, green: 0.239, blue: 0.498, alpha: 1).cgColor
        button.layer.borderColor = UIColor.green.cgColor
        button.setImage(UIImage(named: "location"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.layer.cornerRadius = 15
        //searchBar.barStyle = .default
        searchBar.searchTextField.backgroundColor = UIColor(red: 0.322, green: 0.239, blue: 0.498, alpha: 1)
        searchBar.barTintColor = UIColor(red: 0.322, green: 0.239, blue: 0.498, alpha: 1)
        searchBar.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Поиск города", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.searchTextField.rightView?.tintColor = .white
        searchBar.clipsToBounds = true
        return searchBar
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.cellID)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        return tableView
    }()
    
    
    //MARK: - Constraints
    func configureUIOn(view: UIView) {
        background.configure(on: view)
        view.addSubview(locationButton)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            locationButton.widthAnchor.constraint(equalToConstant: 55),
            locationButton.heightAnchor.constraint(equalToConstant: 55),
            locationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            searchBar.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: locationButton.safeAreaLayoutGuide.leadingAnchor, constant: -10),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}
