//
//  GridConfiguration.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 01/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

struct Slot {
    var cell: SlotableCell
    var params: [String: Any]
}

fileprivate class JSONConfig { // TODO: Isso aqui não precisa ser uma classe!
    
    let slots: [[Slot]]
    
    init(json: JSON) {
        slots = json.arrayValue.map { rows -> [Slot] in
            rows.arrayValue.map { cell -> Slot in
                // cell class
                let cellClass = NSClassFromString("stalkr." + cell["cell"].stringValue)! as! NSObject.Type
                let cellObject = cellClass.init() as! SlotableCell
                
                // cell params
                let params = cell["params"].dictionaryObject!
                
                //
                return Slot(cell: cellObject, params: params)
            }
        }
    }
}

class GridConfiguration { // TODO: Talvez renomear para apenas "Grid"
    
    private var config: JSONConfig?
    let slots: [[Slot]]
    let gridConfigZoomOut: GridConfiguration?
    var isZoom: Bool {
        get {
            return self.gridConfigZoomOut != nil
        }
    }
    
    init(json: JSON) {
        config = JSONConfig(json: json)
        slots = config!.slots
        
        gridConfigZoomOut = nil
    }
    
    init(zoomAtX x: Int, y: Int, grid: GridConfiguration) {
        let slot = grid.slots[y][x]
        slots = [[slot]]
        
        self.gridConfigZoomOut = grid
    }
}
