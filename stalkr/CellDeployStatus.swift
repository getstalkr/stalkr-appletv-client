//
//  CellDeployStatus.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 19/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import Cartography
import GridView

class CellDeployStatus: SlotableCellDefault, SlotableCell, StalkrCell {
    
    @IBOutlet weak var labelCellTitle: UILabel!
    @IBOutlet weak var viewCircleStatus: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var viewDivision: UIView!
    @IBOutlet weak var stackViewSuccessIndex: UIStackView!
    @IBOutlet weak var labelSuccessPercent: UILabel!
    @IBOutlet weak var labelSuccessLegend: UILabel!
    @IBOutlet weak var stackViewCharge: UIStackView!
    @IBOutlet weak var labelChargeValue: UILabel!
    @IBOutlet weak var labelChargeLegend: UILabel!
    static let cellName = "Deploy Status"
    static let slotWidth = 1
    static let slotHeight = 1
    static let haveZoom = false
    
    static let configurations: [ConfigInput] = []
    
    func load(params: [String: Any]) {
        self.viewCircleStatus.layer.cornerRadius = self.viewCircleStatus.frame.width / 2
        self.viewCircleStatus.layer.masksToBounds = true
        self.viewCircleStatus.layer.borderWidth = 7
        self.viewCircleStatus.layer.borderColor = self.viewCircleStatus.backgroundColor?.withAlphaComponent(0.2).cgColor
        self.viewCircleStatus.backgroundColor = UIColor.stalkrSuccess.withAlphaComponent(0)
        
        self.labelStatus.textColor = UIColor.stalkrSuccess
        
        labelSuccessPercent.textColor = UIColor.white
        labelSuccessLegend.textColor = UIColor.cellDeployStatusLabelLegend
        labelChargeValue.textColor = UIColor.white
        labelChargeLegend.textColor = UIColor.cellDeployStatusLabelLegend
        
        // constrains
        constrain(self.labelCellTitle, self.viewCircleStatus, self.viewDivision, self.stackViewSuccessIndex, self.stackViewCharge) { label, circle, division, stackSuccessIndex, stackCharge in
            circle.top == label.bottom + 10
            
            circle.width == 150
            circle.height == 150
            circle.centerX == circle.superview!.centerX
            
            division.width == 2
            division.height == 58
            division.top == circle.bottom + 25
            division.centerX == circle.centerX
            
            stackSuccessIndex.top == division.top
            stackSuccessIndex.centerX == stackSuccessIndex.superview!.centerX * 0.5

            stackCharge.top == division.top
            stackCharge.centerX == stackCharge.superview!.centerX * 1.5
        }
    }

}

extension UIColor {
    static let cellDeployStatusLabelLegend = UIColor.init(red: 161/255, green: 162/255, blue: 191/255, alpha: 1.0)
}
