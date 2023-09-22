//
//  BackgroundLayer.swift
//  WeatherApp_Otus
//
//  Created by Илья Кузнецов on 08.09.2023.
//

import UIKit

class Background: UIView {
    
    var backView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 1
        //view.layer.compositingFilter = "softLightBlendMode"
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "BackgroundImage")
        return view
    }()
    
//    private var layer0: CALayer = {
//        let layer = CALayer()
//        layer.contents = UIImage(named: "BackgroundImage")
//        layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 3.14, b: 0, c: 0, d: 1, tx: -2.14, ty: 0))
//        return layer
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       // layer0.bounds = backView.bounds
        //layer0.position = backView.center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(on view: UIView) {
        view.addSubview(backView)

        backView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
