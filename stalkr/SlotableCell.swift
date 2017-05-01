//
//  CellSlotable.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 06/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import Cartography
import SwiftRichString
import GridView

protocol StalkrCell {
    
    static var cellName: String { get }
    static var haveZoom: Bool { get }
    static var configurations: [ConfigInput] { get }
}

class SlotableCellDefault: UICollectionViewCell, LoadingViewProtocol {
    
    var loadingView: LoadingView?
    
    var scaleWhenFocused: Bool {
        get {
            return true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = UIColor.white.cgColor
        
        // start loading
        self.loadingView = LoadingView(inView: self.contentView, animationType: NVActivityIndicatorType.ballClipRotatePulse)
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
                if self.scaleWhenFocused {
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                
                self.layer.shadowOpacity = 1
            }, completion: {
                
            })
        }
    }
}

class ZoomCell: SlotableCellDefault {
    
    static let cellName = ""
    static let slotWidth = 1
    static let slotHeight = 1
    static let haveZoom = false
    static let configurations: [ConfigInput] = []
    
    override var scaleWhenFocused: Bool {
        get {
            return false
        }
    }

}

// list all classes that subscriber the protocol SlotableCell
let listAllSlotableCell = {
    return subscribers(of: SlotableCell.Type.self )
}()
