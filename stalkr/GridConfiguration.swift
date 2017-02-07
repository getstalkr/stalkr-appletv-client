//
//  GridConfiguration.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 01/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation

struct Slot {
    var application: SlotableCell?
    var params: [String: Any]
}

class GridConfiguration {
    
    static let shared = GridConfiguration()
    let slots: [[Slot]]
    
    private init() {
        /*slots = [
            [Slot(application: CellPlaceholderWidthTwo(), params: [:]), Slot(application: CellPlaceholderHeightTwo(), params: [:])],
            [Slot(application: CellPlaceholderWidthTwo(), params: [:])],
            [Slot(application: CellPlaceholderSmall(), params: ["label": "macabeus é sayajin"]), Slot(application: CellPlaceholderSmall(), params: ["label": "macabeus é lindo"]), Slot(application: CellPlaceholderSmall(), params: ["label": "macabeus é o galã"])]
         ]*/
        
        slots = [
            [Slot(application: CellPlaceholderWidthTwo(), params: [:]), Slot(application: CellPlaceholderHeightTwo(), params: [:])],
            [Slot(application: CellPlaceholderTwoXTwo(), params: [:])],
            [Slot(application: CellPlaceholderSmall(), params: ["label": "macabeus é sayajin"])]
        ]
    }
    
    // todo: add cell
    // todo: remove cell
}
