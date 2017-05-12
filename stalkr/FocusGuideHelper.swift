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

struct FocusGuideConditional {
    let identifier: String?
    let focus: UIFocusGuide
    let condition: (UIFocusUpdateContext) -> (Bool)
}

class FocusGuideHelper: NSObject {

    private var arrayFocus: [UIFocusGuide] = []
    private var arrayFocusAutoexclude: [FocusGuideConditional] = []
    private var arrayFocusActivedWhen: [FocusGuideConditional] = []
    
    func linkByFocus(from view1: UIView, to view2: UIView, inPosition pos: Pos, reduceMeasurement measure: Measurement, inView: UIView? = nil) -> UIFocusGuide {
        
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
        
        return focusGuide
    }
    
    func linkByFocusTemporary(from view1: UIView, to view2: UIView, inPosition pos: Pos, reduceMeasurement measure: Measurement, inView: UIView? = nil) {
        
        let newFocus = linkByFocus(from: view1, to: view2, inPosition: pos, reduceMeasurement: measure, inView: inView)
        
        let focused = UIScreen.main.focusedItem!
        arrayFocusAutoexclude.append(
            FocusGuideConditional(
                identifier: "TEMP of '\(focused)' to '\(view2)'",
                focus: newFocus,
                condition: { context in
                    return context.previouslyFocusedItem?.isEqual(focused) == true
                }
            )
        )
    }
    
    func linkByFocusAutoexclude(from view1: UIView, to view2: UIView, inPosition pos: Pos, reduceMeasurement measure: Measurement, inView: UIView? = nil, closure: @escaping (UIFocusUpdateContext) -> (Bool), identifier: String) {
        
        if (arrayFocusAutoexclude.first { $0.identifier == identifier }) != nil {
            return
        }
        
        let newFocus = linkByFocus(from: view1, to: view2, inPosition: pos, reduceMeasurement: measure, inView: inView)
        
        arrayFocusAutoexclude.append(
            FocusGuideConditional(identifier: identifier, focus: newFocus, condition: closure)
        )
    }

    func linkByFocus(from view1: UIView, to view2: UIView, inPosition pos: Pos, reduceMeasurement measure: Measurement, inView: UIView? = nil, activedWhen closure: @escaping (UIFocusUpdateContext) -> (Bool), identifier: String) {
        
        if (arrayFocusActivedWhen.first { $0.identifier == identifier }) != nil {
            return
        }
        
        let newFocus = linkByFocus(from: view1, to: view2, inPosition: pos, reduceMeasurement: measure, inView: inView)
        
        arrayFocusActivedWhen.append(
            FocusGuideConditional(identifier: identifier, focus: newFocus, condition: closure)
        )
    }
    
    func removeAll() {
        arrayFocus.removeAll()
    }
    
    func disableAll() {
        arrayFocus.forEach { $0.isEnabled = false }
    }
    
    func enableAll() {
        arrayFocus.forEach { $0.isEnabled = true }
    }
    
    func updateFocusTemp(in context: UIFocusUpdateContext) {
        var iteratorAutoexclude = arrayFocusAutoexclude.makeIterator()
        while let element = iteratorAutoexclude.next() {
            
            if element.condition(context) {
                element.focus.isEnabled = false
                arrayFocus.remove(at: arrayFocus.index(of: element.focus)!)
                arrayFocusAutoexclude = arrayFocusAutoexclude.filter {
                    $0.focus != element.focus
                }
            }
            
        }
        
        arrayFocusActivedWhen.forEach { element in
            if element.condition(context) {
                element.focus.isEnabled = true
            } else {
                element.focus.isEnabled = false
            }
        }
    }
}
