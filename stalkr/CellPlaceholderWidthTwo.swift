//
//  CellPlaceholderWidthTwo.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 06/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class CellPlaceholderWidthTwo: SlotableCellDefault, SlotableCell {
    
    static let cellName = "Placeholder With Two"
    let slotWidth = 2
    let slotHeight = 1
    let haveZoom = false
    
    static let configurations: [ConfigInput] = []
    
    func load(params: [String: Any]) { }
}
