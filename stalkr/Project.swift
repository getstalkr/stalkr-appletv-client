//
//  Project.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 09/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import TvLightSegments
import GridView

class Project {
    let name: String
    var slots: Slots
    
    init(name: String, cells: [[(SlotableCell.Type, [String: Any])]]) {
        self.name = name
        
        let slotsArray = cells.map { $0.map { Slot(cell: $0, params: $1) } }
        self.slots = Slots(slots: slotsArray)
    }
}

extension Project: TvLightSegmentsItem {
    
    func tvLightSegmentsName() -> String {
        return name
    }
}
