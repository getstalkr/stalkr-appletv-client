//
//  CellProjectTab.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 04/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class CellProjectTab: UICollectionViewCell {
    
    @IBOutlet weak var labelProjectName: UILabel!
    @IBOutlet weak var viewFooterLeft: UIView!
    @IBOutlet weak var viewFooterCenter: UIView!
    @IBOutlet weak var viewFooterRight: UIView!
    
    var project: Project?
    var grid: ProjectViewProtocol?
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if self === context.previouslyFocusedItem {
            
            if ((context.nextFocusedItem as? CellProjectTab) != nil) {
                coordinator.addCoordinatedAnimations({
                    self.changeToNotSelected()
                }, completion: {
                    
                })
            } else {
                coordinator.addCoordinatedAnimations({
                    self.changeToSelected()
                }, completion: {
                    
                })
            }
        } else if self === context.nextFocusedItem {
            project!.show(grid: grid!)
            
            coordinator.addCoordinatedAnimations({
                self.changeToFocused()
            }, completion: {
                
            })
        }
    }
    
    func changeToNotSelected() {
        self.viewFooterCenter.backgroundColor = UIColor.projectTabNotSelected
        self.labelProjectName.textColor = UIColor.projectTabNotSelected
        self.viewFooterLeft.layer.shadowOpacity = 0
        self.viewFooterCenter.layer.shadowOpacity = 0
        self.viewFooterRight.layer.shadowOpacity = 0
    }
    
    func changeToSelected() {
        self.viewFooterCenter.backgroundColor = UIColor.projectTabSelected
        self.labelProjectName.textColor = UIColor.projectTabSelected
        self.viewFooterLeft.layer.shadowOpacity = 0
        self.viewFooterCenter.layer.shadowOpacity = 0
        self.viewFooterRight.layer.shadowOpacity = 0
    }
    
    func changeToFocused() {
        self.viewFooterCenter.backgroundColor = UIColor.projectTabSelected
        self.labelProjectName.textColor = UIColor.projectTabSelected
        self.viewFooterLeft.layer.shadowOpacity = 1
        self.viewFooterCenter.layer.shadowOpacity = 1
        self.viewFooterRight.layer.shadowOpacity = 1
    }
}

extension UIColor {
    static let projectTabSelected = UIColor.init(red: 141/255, green: 102/255, blue: 189/255, alpha: 1.0)
    static let projectTabNotSelected = UIColor.init(red: 108/255, green: 114/255, blue: 143/255, alpha: 1.0)
}
