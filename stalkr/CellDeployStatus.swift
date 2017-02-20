//
//  CellDeployStatus.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 19/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class CellDeployStatus: SlotableCellDefault, SlotableCell {
    
    @IBOutlet weak var viewCircleStatus: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelSuccessPercent: UILabel!
    @IBOutlet weak var labelSuccessLegend: UILabel!
    @IBOutlet weak var labelChargeValue: UILabel!
    @IBOutlet weak var labelChargeLegend: UILabel!
    let slotWidth = 1
    let slotHeight = 1
    
    func load(params: [String: Any]) {
        self.viewCircleStatus.layer.cornerRadius = self.viewCircleStatus.frame.width / 2
        self.viewCircleStatus.layer.masksToBounds = true
        self.viewCircleStatus.layer.borderWidth = 7
        self.viewCircleStatus.layer.borderColor = self.viewCircleStatus.backgroundColor?.withAlphaComponent(0.2).cgColor
        self.viewCircleStatus.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        self.labelStatus.textColor = UIColor.stalkrSuccess
        
        labelSuccessPercent.textColor = UIColor.white
        labelSuccessLegend.textColor = UIColor.cellDeployStatusLabelLegend
        labelChargeValue.textColor = UIColor.white
        labelChargeLegend.textColor = UIColor.cellDeployStatusLabelLegend
    }

}

extension UIColor {
    static let cellDeployStatusLabelLegend = UIColor.init(red: 161/255, green: 162/255, blue: 191/255, alpha: 1.0)
}
