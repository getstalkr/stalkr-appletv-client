//
//  GridConfiguration.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 01/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation

struct Slot {
    var cell: SlotableCell?
    var params: [String: Any]
}

class GridConfiguration {
    
    static let shared = GridConfiguration()
    let slots: [[Slot]]
    
    private init() {
        slots = [
            [Slot(cell: CellPlaceholderWidthTwo(), params: [:]), Slot(cell: CellPlaceholderHeightTwo(), params: [:])],
            [Slot(cell: CellPlaceholderWidthTwo(), params: [:])],
            [Slot(cell: CellPlaceholderSmall(), params: ["label": "macabeus é sayajin"]), Slot(cell: CellPlaceholderSmall(), params: ["label": "macabeus é lindo"]), Slot(cell: CellPlaceholderSmall(), params: ["label": "macabeus é o galã"])]
         ]
        
        /*slots = [
            [Slot(cell: CellPlaceholderWidthTwo(), params: [:]), Slot(cell: CellPlaceholderHeightTwo(), params: [:])],
            [Slot(cell: CellPlaceholderTwoXTwo(), params: [:])],
            [Slot(cell: CellPlaceholderSmall(), params: ["label": "macabeus é sayajin"])]
        ]*/
    }
    
    // todo: add cell
    // todo: remove cell
}
