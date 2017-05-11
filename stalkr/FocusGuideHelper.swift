//
//  FocusGuideHelper.swift
//  stalkr
//
//  Created by Edvaldo Junior on 06/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

enum Pos {    
    case up
    case left
    case down
    case right
}

enum Measurement {    
    case width
    case height
    case none
    case widthAndHeight
}

class FocusGuideHelper: NSObject {

    var arrayFocus: [UIFocusGuide]
    
    func linkByFocus(from view1: UIView, to view2: UIView, inPosition pos: Pos, reduceMeasurement measure: Measurement, inView: UIView? = nil) {
        
        let focusGuide = UIFocusGuide()
        if inView == nil {
            view1.superview?.addLayoutGuide(focusGuide)
        } else {
            inView!.addLayoutGuide(focusGuide)
        }
        
        switch measure {
            case .height:
                focusGuide.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
                focusGuide.heightAnchor.constraint(equalToConstant: 10).isActive = true
            case .width:
                focusGuide.widthAnchor.constraint(equalToConstant: 10).isActive = true
                focusGuide.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
            case .none:
                focusGuide.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
                focusGuide.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
            case .widthAndHeight:
                focusGuide.widthAnchor.constraint(equalToConstant: 10).isActive = true
                focusGuide.heightAnchor.constraint(equalToConstant: 10).isActive = true
        }
        
        switch pos {
        case .up:
            focusGuide.bottomAnchor.constraint(equalTo: view1.topAnchor, constant: -5).isActive = true
        case .down:
            focusGuide.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 5).isActive = true
        case .left:
            focusGuide.trailingAnchor.constraint(equalTo: view1.leadingAnchor, constant: -(focusGuide.layoutFrame.width * 2) - 1).isActive = true
        case .right:
            focusGuide.leadingAnchor.constraint(equalTo: view1.trailingAnchor, constant: 2).isActive = true
        }
        
        focusGuide.centerYAnchor.constraint(equalTo: view1.centerYAnchor).isActive = true
        focusGuide.preferredFocusEnvironments = [view2]
        
        
        arrayFocus.append(focusGuide)
    }
    
    func deseable() {
        for guide in arrayFocus {
            guide.isEnabled = false
        }
    }
    
    func enable() {
        for guide in arrayFocus {
            guide.isEnabled = true
        }
        
    }
    
    init(withArrayOfFocus focus: [UIFocusGuide]) {
        arrayFocus = focus
    }
}
