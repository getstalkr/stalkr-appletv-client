//
//  Project.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 09/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON
import TvLightSegments
import GridView

class Project {
    let name: String
    var slots: [[Slot]]
    
    init(json: JSON) {
        self.name = json.dictionaryValue["name"]!.stringValue
        
        // create slots from JSON
        slots = json.dictionaryValue["grid"]!.map { _, rows -> [Slot] in
            rows.arrayValue.map { cell -> Slot in
                let cellClass = NSClassFromString("stalkr." + cell["cell"].stringValue)! as! NSObject.Type
                let params = cell["params"].dictionaryObject!
                
                return Slot(cell: cellClass as! SlotableCell.Type, params: params)
            }
        }
    }

}

extension Project: TvLightSegmentsItem {
    
    func tvLightSegmentsName() -> String {
        return name
    }
}
