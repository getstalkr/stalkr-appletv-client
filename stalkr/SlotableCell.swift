//
//  CellSlotable.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 06/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import UIKit

protocol SlotableCell {
    var slotWidth: Int { get }
    var slotHeight: Int { get }
    
    func load(params: [String: Any])
}

class SlotableCellDefault: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = UIColor.white.cgColor
    }
    
    override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if self === context.previouslyFocusedItem {
            
            coordinator.addCoordinatedAnimations({
                self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                
                self.layer.shadowOpacity = 0.0
            }, completion: {
                
            })
        } else if self === context.nextFocusedItem {
            
            coordinator.addCoordinatedAnimations({
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                self.layer.shadowOpacity = 1
            }, completion: {
                
            })
        }
    }
}

// lista com todos as classes que implementam o protocolo SlotableCell
// todo: talvez haja alguma forma mística de gerar essa listagem automaticamente
let listAllSlotableCell: [NSObject.Type] = [
    CellPlaceholderSmall.self,
    CellPlaceholderWidthTwo.self,
    CellPlaceholderHeightTwo.self,
    CellPlaceholderTwoXTwo.self
]
