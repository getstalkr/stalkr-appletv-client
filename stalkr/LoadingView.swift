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
    var loadingView: LoadingView? { get set }
}

class LoadingView {
    var animation: NVActivityIndicatorView
    var label: UILabel
    
    init(inView view: UIView, animationType: NVActivityIndicatorType) {
        animation = NVActivityIndicatorView(frame: view.frame, type: animationType)
        animation.color = UIColor.init(red: 184/255, green: 101/255, blue: 210/255, alpha: 0.2)
        animation.alpha = 0
        
        label = UILabel(frame: view.frame)
        label.numberOfLines = 0
        label.text = ""
        label.textColor = UIColor.init(red: 184/255, green: 101/255, blue: 210/255, alpha: 0.9)
        
        view.addSubview(animation)
        view.addSubview(label)
        
        constrain(animation, label) { animate, label in
            animate.width == animate.superview!.width * 2 / 3
            animate.height == animate.width
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
