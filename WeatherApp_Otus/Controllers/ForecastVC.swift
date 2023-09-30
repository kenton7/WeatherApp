//
//  ForecastVC.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 21.09.2023.
//

import UIKit

final class ForecastVC: UIViewController {
    
    private let forecastViews = ForecastViews()
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.cellID)
        return tableView
    }()
    var forecastModel = [ForecastModel]()
    private var searchVC = SearchVC()
    
    private lazy var spinner: CustomLoaderView = {
        let spinner = CustomLoaderView(squareLength: 100)
        spinner.isHidden = true
        return spinner
    }()
    
    var coordinates: Coordinates?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Прогноз на 5 дней"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        forecastViews.configure(on: view)
        view.addSubview(spinner)
        forecastViews.tableView.delegate = self
        forecastViews.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.alpha = 1.0
        ForecastManager.shared.getForecast(latitude: coordinates?.latitude ?? 0.0, longtitude: coordinates?.longitude ?? 0.0) { forecast in
            DispatchQueue.main.async {
                self.spinner.isHidden = false
            }
            self.weather = forecast
        }
        
        DispatchQueue.main.async {
            self.forecastViews.setupData(items: self.forecastModel)
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.alpha = 0.0
    }
    
    private var weather = [ForecastModel]() {
        didSet {
            DispatchQueue.main.async {
                self.forecastViews.tableView.reloadData()
                self.spinner.isHidden = true
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ForecastVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.cellID, for: indexPath) as! ForecastTableViewCell
        cell.setupData(items: weather, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
