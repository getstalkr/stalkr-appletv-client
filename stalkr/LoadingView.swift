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
    var animation: NVActivityIndicatorView
    var label: UILabel
    
    init(inView view: UIView, animationType: NVActivityIndicatorType) {
        let size = min(view.frame.width, view.frame.height)
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
        
        view.addSubview(animation)
        view.addSubview(label)
        
        constrain(animation, label) { animate, label in
            animate.width == animate.width
            animate.height == animate.height
            animate.center == animate.superview!.center
            
            label.center == animate.center
        }
    }

    func show(message: String) {
        animation.alpha = 1
        animation.startAnimating()
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
        animation.alpha = 0
        animation.stopAnimating()
        label.alpha = 0
    }
}
