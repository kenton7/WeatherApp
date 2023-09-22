//
//  TabBarController.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 08.09.2023.
//

import UIKit


class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateTabBar()
        setTabBarAppearence()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func generateTabBar() {
        viewControllers = [
            generateVC(viewController: MainVC(), image: UIImage(systemName: "house.fill")!, title: nil),
            generateVC(viewController: SearchVC(), image: UIImage(systemName: "magnifyingglass")!, title: nil),
            generateVC(viewController: SettingsVC(), image: UIImage(systemName: "gear")!, title: nil)
        ]
    }
    
    private func generateVC(viewController: UIViewController, image: UIImage, title: String?) -> UIViewController {
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setTabBarAppearence() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: positionOnX,
                                                          y: tabBar.bounds.minY - positionOnY,
                                                          width: width,
                                                          height: height),
                                      cornerRadius: height / 2)
        
        roundLayer.path = bezierPath.cgPath
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered

        
        roundLayer.fillColor = UIColor.backgroundColorTabBar.cgColor
        tabBar.tintColor = UIColor.tabBarItemSelected
        tabBar.unselectedItemTintColor = UIColor.tabBarItemNonSelected
    }
}
