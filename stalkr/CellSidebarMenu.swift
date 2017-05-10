//
//  CellSidebarMenu.swift
//  stalkr
//
//  Created by Edvaldo Junior on 21/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class CellSidebarMenu: UITableViewCell {
    
    let alphaNotFocused: CGFloat = 0.5
    var sidebarProtocol: SidebarProtocol?
    var myOption: SidebarOptions? {
        willSet(newValue) {
            self.textLabel!.text = newValue!.description
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.alpha = alphaNotFocused
        self.textLabel!.textColor = .white
        self.contentView.backgroundColor = .clear
        self.focusStyle = .custom
    }
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if self === context.nextFocusedItem {
            sidebarProtocol?.focusedCell(withOption: self.myOption!)
            
            self.changeUiToFocused()
        }
        
        if self === context.previouslyFocusedItem {
            
            if context.nextFocusedItem != nil && type(of: context.nextFocusedItem!) != type(of: self)  {
                self.changeUiToSelected()
            } else {
                self.changeUiToNotSelected()
            }
        }
    }
    
    func changeUiToNotSelected() {
        self.contentView.alpha = alphaNotFocused
        self.contentView.backgroundColor = .clear
    }
    
    func changeUiToSelected() {
        self.contentView.alpha = alphaNotFocused
        self.contentView.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1137254902, blue: 0.2117647059, alpha: 0.8008882705)
    }
    
    func changeUiToFocused() {
        self.contentView.alpha = 1.0
        self.contentView.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1137254902, blue: 0.2117647059, alpha: 1)
    }
}
