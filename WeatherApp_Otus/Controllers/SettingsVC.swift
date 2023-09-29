//
//  SettingsVC.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 08.09.2023.
//

import UIKit

final class SettingsVC: UIViewController {
    
    private let background = Background()
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.cellID)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        return tableView
    }()
    
    private let settingsVC = SettingsViews()
    private var selectedIndexPath: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        background.configure(on: self.view)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        constraintsTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func constraintsTableView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func windSegmentedControlPressed(segment: UISegmentedControl) {
        let selectedParameter = segment.titleForSegment(at: segment.selectedSegmentIndex)
        UserDefaults.standard.set(selectedParameter, forKey: "windTitle")
        UserDefaults.standard.set(segment.selectedSegmentIndex, forKey: "windIndex")
    }
    
    @objc private func pressureSegmentedPressed(segment: UISegmentedControl) {
        let selectedParameter = segment.titleForSegment(at: segment.selectedSegmentIndex)
        UserDefaults.standard.set(selectedParameter, forKey: "pressureTitle")
        UserDefaults.standard.set(segment.selectedSegmentIndex, forKey: "pressureIndex")
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let verticalPadding: CGFloat = 10
//
//        let maskLayer = CALayer()
//        maskLayer.cornerRadius = 15
//        maskLayer.backgroundColor = UIColor.black.cgColor
//        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height * 2).insetBy(dx: 0, dy: verticalPadding / 2)
//        cell.layer.mask = maskLayer
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Температура"
        case 1:
            return "Другие единицы измерения"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.cellID, for: indexPath) as! SettingsTableViewCell
//        cell.segmentedControlForWind.addTarget(self, action: #selector(windSegmentedControlPressed), for: .valueChanged)
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.cellID, for: indexPath) as! SettingsTableViewCell
            if indexPath.row == UserDefaults.standard.integer(forKey: "selectedItem") {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            cell.temperatureLabel.text = MeasureType.allCases[indexPath.row].rawValue
            return cell
        } else {
            let cell = OtherMeasurementsCell(style: .default, reuseIdentifier: OtherMeasurementsCell.cellID)
            cell.contentView.isUserInteractionEnabled = false // чтобы можно было нажать на segmeted control в ячейке
            cell.segmentedControlForWind.addTarget(self, action: #selector(windSegmentedControlPressed), for: .valueChanged)
            cell.segmetedControlForPressure.addTarget(self, action: #selector(pressureSegmentedPressed), for: .valueChanged)
            cell.parameterLabel.text = MeasureType.allCases[indexPath.row + 2].rawValue
            if indexPath.row == 0 {
                cell.segmetedControlForPressure.isHidden = true
                
                if let value = UserDefaults.standard.value(forKey: "windIndex") {
                    let selectedIndex = value as! Int
                    cell.segmentedControlForWind.selectedSegmentIndex = selectedIndex
                }
            } else {
                cell.segmentedControlForWind.isHidden = true
                if let value = UserDefaults.standard.value(forKey: "pressureIndex") {
                    let selectedIndex = value as! Int
                    cell.segmetedControlForPressure.selectedSegmentIndex = selectedIndex
                }
            }
            cell.accessoryType = .none
            return cell
        }
        //return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            selectedIndexPath = indexPath.row
            
            if indexPath.row == 0 {
                UserDefaults.standard.setValue("metric", forKey: "units")
            } else {
                UserDefaults.standard.setValue("imperial", forKey: "units")
            }
            UserDefaults.standard.setValue(selectedIndexPath, forKey: "selectedItem")
            UserDefaults.standard.synchronize()
            tableView.reloadData()
        } else {
            print(indexPath.section)
        }
    }
}

