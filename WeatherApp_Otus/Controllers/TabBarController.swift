//
//  TabBarController.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 08.09.2023.
//

import UIKit


class TabBarController: UITabBarController {
    
    private let tabBarView = TabBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.setValue(tabBarView, forKey: "tabBar")
        generateTabBar()
        self.selectedIndex = 0
        //setTabBarAppearence()
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
}

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let tabBar = tabBar as? TabBarView {
            tabBar.updateCurveForTappedIndex()
        }
    }
}
