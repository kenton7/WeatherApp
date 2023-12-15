//
//  SettingsVC.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 08.09.2023.
//

import UIKit

enum MeasurementsTypes: String {
    case mmRtSt = "мм.рт.ст."
    case hPa = "гПа"
    case dRtSt = "д.рт.ст."
    case metersPerSecond = "м/c"
    case kilometerPerHour = "км/ч"
    case milesPerHour = "ми/ч"
    case mertic = "metric"
    case imperial = "imperial"
    case wind = "windTitle"
    case pressure = "pressureTitle"
}

final class SettingsVC: UIViewController {
    
    private let settingsVC = SettingsViews()
    private var selectedIndexPath: Int?
    
    override func loadView() {
        super.loadView()
        view = settingsVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsVC.tableView.dataSource = self
        settingsVC.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc private func windSegmentedControlPressed(segment: UISegmentedControl) {
        let selectedParameter = segment.titleForSegment(at: segment.selectedSegmentIndex)
        UserDefaults.standard.set(selectedParameter, forKey: MeasurementsTypes.wind.rawValue)
        UserDefaults.standard.set(segment.selectedSegmentIndex, forKey: "windIndex")
        print(segment.selectedSegmentIndex)
        print(UserDefaults.standard.integer(forKey: "windIndex"))
    }
    
    @objc private func pressureSegmentedPressed(segment: UISegmentedControl) {
        let selectedParameter = segment.titleForSegment(at: segment.selectedSegmentIndex)
        UserDefaults.standard.set(selectedParameter, forKey: MeasurementsTypes.pressure.rawValue)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            selectedIndexPath = indexPath.row
            
            if indexPath.row == 0 {
                UserDefaults.standard.setValue(MeasurementsTypes.mertic.rawValue, forKey: "units")
            } else {
                UserDefaults.standard.setValue(MeasurementsTypes.imperial.rawValue, forKey: "units")
            }
            UserDefaults.standard.setValue(selectedIndexPath, forKey: "selectedItem")
            UserDefaults.standard.synchronize()
            settingsVC.tableView.reloadData()
        }
    }
}
