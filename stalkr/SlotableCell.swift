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

protocol SlotableCell {
    
    static var cellName: String { get }
    var slotWidth: Int { get }
    var slotHeight: Int { get }
    var haveZoom: Bool { get }
    static var configurations: [ConfigInput] { get }
    
    func load(params: [String: Any])
}

class SlotableCellDefault: UICollectionViewCell {
    
    var loadingView: NVActivityIndicatorView?
    var loadingLabel: UILabel?
    
    var scaleWhenFocused: Bool {
        get {
            return true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = UIColor.white.cgColor
        
        // start loading views
        // TODO: talvez seja bom jogar toda essa lógica de loading num protocol
        loadingView = NVActivityIndicatorView(frame: self.contentView.frame,
                                              type: NVActivityIndicatorType.ballClipRotatePulse)
        loadingView!.color = UIColor.init(red: 184/255, green: 101/255, blue: 210/255, alpha: 0.2)
        loadingView!.alpha = 0
        
        loadingLabel = UILabel(frame: frame)
        loadingLabel!.numberOfLines = 0
        loadingLabel!.text = ""
        loadingLabel!.textColor = UIColor.init(red: 184/255, green: 101/255, blue: 210/255, alpha: 0.9)
        
        self.contentView.addSubview(loadingView!)
        self.contentView.addSubview(loadingLabel!)

        constrain(loadingView!, loadingLabel!) { animate, label in
            animate.width == animate.superview!.width * 2 / 3
            animate.height == animate.width
            animate.center == animate.superview!.center
            
            label.center == animate.center
        }
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
    
    // loadings methods
    func showLoading(message: String) {
        loadingView!.alpha = 1
        loadingView!.startAnimating()
        loadingLabel!.text = message
    }

    func errorLoading(message: String) {
        loadingView!.stopAnimating()
        loadingLabel!.attributedText = "Oops\n" + message.set(style: Style({
            $0.font = FontAttribute(FontName.HelveticaNeue, size: 15)
        }))
        loadingLabel!.textColor = UIColor.stalkrError
    }

    func stopLoading() {
        loadingView!.alpha = 0
        loadingView!.stopAnimating()
        loadingLabel!.alpha = 0
    }
    
}

class ZoomCell: SlotableCellDefault {
    
    static let cellName = ""
    let slotWidth = 1
    let slotHeight = 1
    let haveZoom = false
    static let configurations: [ConfigInput] = []
    
    override var scaleWhenFocused: Bool {
        get {
            return false
        }
    }

}

// lista com todos as classes que implementam o protocolo SlotableCell
// todo: talvez haja alguma forma mística de gerar essa listagem automaticamente
let listAllSlotableCell: [NSObject.Type] = [
    CellTrevis.self,
    CellCommitsFeed.self,
    CellTeamCommits.self,
    CellTeamCommitsZoom.self,
    CellCloudPerformance.self,
    CellDeployStatus.self
]
