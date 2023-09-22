//
//  ForecastTableViewCell.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 21.09.2023.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    static let cellID = "ForecastTableViewCell"
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = false
        backgroundColor = UIColor(red: 0.322, green: 0.239, blue: 0.498, alpha: 1)
        alpha = 0.8
        layer.cornerRadius = 15
        isUserInteractionEnabled = false
        selectionStyle = .none
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
