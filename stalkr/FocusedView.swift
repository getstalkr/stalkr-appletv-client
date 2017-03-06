//
//  FocusedView.swift
//  stalkr
//
//  Created by Edvaldo Junior on 06/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class FocusedView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override var canBecomeFocused: Bool {
        return true
    }

}
