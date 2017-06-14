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
    static var configurations: [StalkrCellConfig] { get }
}

class SlotableCellDefault: UICollectionViewCell, LoadingViewProtocol {
    
    lazy var loadingView: LoadingView = {
        // get label cell title
        let labelCellTitle = self.contentView.subviews
            .filter { ($0 as? UILabel) != nil }
            .sorted { $0.frame.minY > $1.frame.minY }
            .first
        
        var hideExcept: [UIView] = []
        if let labelCellTitle = labelCellTitle {
            hideExcept.append(labelCellTitle)
        }
        
        //
        return LoadingView(
            inView: self.contentView,
            animationType: NVActivityIndicatorType.ballClipRotatePulse,
            hideExcept: hideExcept
        )
    }()
    
    var params: [String : Any] = [:]
    
    var scaleWhenFocused: Bool {
        get {
            return true
        }
    }
    
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
                self.layer.shadowOpacity = 0.0
            }, completion: {
                
            })
        } else if self === context.nextFocusedItem {
            
            coordinator.addCoordinatedAnimations({
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
    static let configurations: [StalkrCellConfig] = []
    
    override var scaleWhenFocused: Bool {
        get {
            return false
        }
    }

}

// list all classes that subscriber the protocol SlotableCell
let listAllSlotableCell: [ClassInfo] = [ClassInfo(CellCloudPerformance.self)!, ClassInfo(CellTrevis.self)!, ClassInfo(CellCommitsFeed.self)!]
/*let listAllSlotableCell = {
    return subscribers(of: SlotableCell.Type.self )
}()*/
