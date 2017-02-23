//
//  SegmentedControl.swift
//  stalkr
//
//  Created by Edvaldo Junior on 21/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

//
//  ADVSegmentedControl.swift
//  Mega
//
//  Created by Tope Abayomi on 01/12/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import UIKit

@IBDesignable class SegmentedControl: UIControl {
    
    fileprivate var labels: [UILabel] = []
    var thumbView = UIView()
    
    var items: [String] = ["Main Dashboard", "Detailed Dashboard"] {
        didSet {
            setupLabels()
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    @IBInspectable var selectedLabelColor: UIColor = UIColor(netHex: 0xB263B2) {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var unselectedLabelColor: UIColor = UIColor(netHex: 0x6C728F) {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var thumbColor: UIColor = UIColor(netHex: 0x8D66BD) {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var font: UIFont! = UIFont.systemFont(ofSize: 25) {
        didSet {
            setFont()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setupView()
    }
    
    func setupView(){
        
        backgroundColor = UIColor.clear
        
        setupLabels()
        
        addIndividualItemConstraints(labels, mainView: self, padding: 0)
        
        insertSubview(thumbView, at: 0)
    }
    
    func setupLabels(){
        
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for index in 0...items.count - 1 {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
            label.text = items[index]
            label.backgroundColor = UIColor.clear
            label.textAlignment = .left
            label.font = UIFont(name: "Avenir-Black", size: 20)
            label.textColor = index == 0 ? selectedLabelColor : unselectedLabelColor
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            labels.append(label)
        }
        
        addIndividualItemConstraints(labels, mainView: self, padding: 0)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = CGRect(x: selectFrame.minX, y: selectFrame.maxY, width: selectFrame.width, height: selectFrame.height * 0.1)
        thumbView.backgroundColor = thumbColor
        
        displayNewSelectedIndex()
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        var calculatedIndex : Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func displayNewSelectedIndex(){
        
        for (_, item) in labels.enumerated() {
            item.textColor = unselectedLabelColor
        }
        
        let label = labels[selectedIndex]
        label.textColor = selectedLabelColor        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.curveLinear, animations: {
            self.thumbView.frame = CGRect(x: label.frame.minX, y: label.frame.maxY, width: label.frame.width, height: label.frame.height * 0.1)
        }, completion: nil)
    }
    
    func addIndividualItemConstraints(_ items: [UIView], mainView: UIView, padding: CGFloat) {
        
        _ = mainView.constraints
        
        for (index, button) in items.enumerated() {
            let topConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
            
            var rightConstraint: NSLayoutConstraint!
            
            if index == items.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -padding)
            } else {
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: nextButton, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: -padding)
            }
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: padding)
            } else {
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: prevButton, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: padding)
                
                let firstItem = items[0]
                
                let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: firstItem, attribute: .width, multiplier: 1.0  , constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    func setSelectedColors(){
        
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        if labels.count > 0 {
            labels[0].textColor = selectedLabelColor
        }
        
        thumbView.backgroundColor = thumbColor
    }
    
    func setFont(){
        for item in labels {
            item.font = font
        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        print("\nUPDATE\n")
        
        if let nextItem = context.nextFocusedView {
            //nextItem.backgroundColor = .blue
        }
        if let previousItem = context.previouslyFocusedView {
            //previousItem.backgroundColor = .clear
        }
    }
}

extension UILabel {
    open override var canBecomeFocused: Bool {
        return true
    }
}
