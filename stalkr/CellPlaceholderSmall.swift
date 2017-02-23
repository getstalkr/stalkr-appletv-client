//
//  CellPlaceholderSmall.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 06/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class CellPlaceholderSmall: SlotableCellDefault, SlotableCell {
    
    @IBOutlet weak var label: UILabel!
    let slotWidth = 1
    let slotHeight = 1
    let haveZoom = false
    var alertMessage: String?
    
    func load(params: [String: Any]) {
        self.label.text = (params["label"] as! String)
        
        if let paramAlert = params["alert"] as? String {
            self.alertMessage = paramAlert
        }
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        if let alertMessage = self.alertMessage {
            self.label.text = alertMessage
        } else {
            self.label.text = "sem alerta definido"
        }
    }
}
