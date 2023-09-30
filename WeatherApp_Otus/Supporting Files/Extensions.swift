//
//  Extensions.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 30.09.2023.
//

import Foundation
import UIKit

//MARK: - UIColor
extension UIColor {
    static var tabBarItemSelected: UIColor = .white
    static var backgroundColorTabBar: UIColor = UIColor(red: 0.322, green: 0.239, blue: 0.498, alpha: 1)
    static var mainWhite: UIColor = .white
    static var tabBarItemNonSelected: UIColor = .gray
}

//MARK: - UIImage
extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func addBackgroundCircle(_ color: UIColor?) -> UIImage? {

        let circleDiameter = max(size.width * 2, size.height * 2)
        let circleRadius = circleDiameter * 0.5
        let circleSize = CGSize(width: circleDiameter, height: circleDiameter)
        let circleFrame = CGRect(x: 0, y: 0, width: circleSize.width, height: circleSize.height)
        let imageFrame = CGRect(x: circleRadius - (size.width * 0.5), y: circleRadius - (size.height * 0.5), width: size.width, height: size.height)

        let view = UIView(frame: circleFrame)
        view.backgroundColor = color ?? .systemRed
        view.layer.cornerRadius = circleDiameter * 0.5

        UIGraphicsBeginImageContextWithOptions(circleSize, false, UIScreen.main.scale)

        let renderer = UIGraphicsImageRenderer(size: circleSize)
        let circleImage = renderer.image { ctx in
            view.drawHierarchy(in: circleFrame, afterScreenUpdates: true)
        }

        circleImage.draw(in: circleFrame, blendMode: .normal, alpha: 1.0)
        draw(in: imageFrame, blendMode: .normal, alpha: 1.0)

        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }
}

//MARK: - String
extension String {
    func configureWeatherDescription(info: String) -> String {
        
        var finalStr = ""
        
        let separatedDescription = info.components(separatedBy: " ")
        let finalDescription = "\(separatedDescription[0].capitalized )\n\(separatedDescription.last ?? "")"
        
        if separatedDescription.count == 2 {
            finalStr = finalDescription
        } else if separatedDescription.count == 3 {
            finalStr = "\(separatedDescription[0].capitalized ) \(separatedDescription[1] )\n\(separatedDescription.last ?? "")"
        } else {
            finalStr = info.prefix(1).uppercased() + (info.lowercased().dropFirst())
        }
        
        return finalStr
    }
}
