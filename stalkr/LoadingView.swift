//
//  LoadingProtocol.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 30/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Cartography
import SwiftRichString


protocol LoadingViewProtocol {
    var loadingView: LoadingView { get }
}

class LoadingView {
    private let animation: NVActivityIndicatorView
    private let label: UILabel
    private let superView: UIView
    private let hideExcept: [UIView]
    private var hidded: [UIView] = []
    
    init(inView view: UIView, animationType: NVActivityIndicatorType, hideExcept: [UIView]) {
        superView = view
        self.hideExcept = hideExcept
        
        let size = min(superView.frame.width, superView.frame.height)
        animation = NVActivityIndicatorView(
            frame: CGRect(x: 0, y: 0, width: size, height: size),
            type: animationType
        )
        animation.color = #colorLiteral(red: 0.7215686275, green: 0.3960784314, blue: 0.8235294118, alpha: 0.2)
        animation.alpha = 0
        
        label = UILabel(frame: view.frame)
        label.numberOfLines = 0
        label.text = ""
        label.textColor = #colorLiteral(red: 0.7215686275, green: 0.3960784314, blue: 0.8235294118, alpha: 0.9)
        
        superView.addSubview(animation)
        superView.addSubview(label)
        
        constrain(animation, label) { animate, label in
            animate.width == animate.width
            animate.height == animate.height
            animate.center == animate.superview!.center
            
            label.center == animate.center
        }
    }

    func show(message: String) {
        superView.subviews.forEach {
            if !($0 === label || $0 === animation || hideExcept.contains($0)) {
                $0.alpha = 0
                hidded.append($0)
            }
        }
        
        animation.alpha = 1
        animation.startAnimating()
        label.alpha = 1
        label.text = message
    }
    
    func error(message: String) {
        animation.stopAnimating()
        label.attributedText = "Oops\n" + message.set(style: Style({
            $0.font = FontAttribute(FontName.HelveticaNeue, size: 15)
        }))
        label.textColor = UIColor.stalkrError
    }
    
    func stop() {
        hidded.forEach { $0.alpha = 1 }
        hidded.removeAll()
        
        superView.subviews.forEach {
            $0.alpha = 1
        }
        
        animation.alpha = 0
        animation.stopAnimating()
        label.alpha = 0
    }
}
