//
//  FocusGuideHelper.swift
//  stalkr
//
//  Created by Edvaldo Junior on 06/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

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
            case .Height:
                focusGuide.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
                focusGuide.heightAnchor.constraint(equalToConstant: 10).isActive = true
            case .Width:
                focusGuide.widthAnchor.constraint(equalToConstant: 10).isActive = true
                focusGuide.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
            case .None:
                focusGuide.widthAnchor.constraint(equalTo: view1.widthAnchor).isActive = true
                focusGuide.heightAnchor.constraint(equalTo: view1.heightAnchor).isActive = true
            case .WidthAndHeight:
                focusGuide.widthAnchor.constraint(equalToConstant: 10).isActive = true
                focusGuide.heightAnchor.constraint(equalToConstant: 10).isActive = true
        }
        
        switch pos {
        case .Up:
            focusGuide.bottomAnchor.constraint(equalTo: view1.topAnchor, constant: -5).isActive = true
        case .Down:
            focusGuide.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 5).isActive = true
        case .Left:
            focusGuide.trailingAnchor.constraint(equalTo: view1.leadingAnchor, constant: -2).isActive = true
        case .Right:
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
    
    init(withArrayOfFocus focus: [UIFocusGuide]) {
        arrayFocus = focus
    }
}
