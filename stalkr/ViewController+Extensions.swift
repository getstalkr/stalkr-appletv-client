//
//  ViewController+Extensions.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 01/07/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setDefaultBackground() {
        let gradientLayer = CAGradientLayer()
        self.view.backgroundColor = .white
        
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor(netHex: 0x543663).cgColor
        let color2 = UIColor(netHex: 0x483159).cgColor
        let color3 = UIColor(netHex: 0x453158).cgColor
        let color4 = UIColor(netHex: 0x242741).cgColor
        gradientLayer.colors = [color1, color2, color3, color4]
        
        gradientLayer.startPoint = CGPoint(x: 0.35, y: 0.25)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.6)
        gradientLayer.zPosition = -1
        
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    func changeRootViewController(toInitialAtStoryboard storyboardName: String) {
        let initialViewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()!
        self.changeRootViewController(to: initialViewController)
    }
    
    func changeRootViewController(to newRoot: UIViewController) {
        UIApplication.shared.delegate?.window??.rootViewController = newRoot
    }
}
