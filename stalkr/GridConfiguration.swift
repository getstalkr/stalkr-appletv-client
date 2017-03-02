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

let rawConfig = [
    "[" +
        "[" +
            "{ \"cell\": \"CellCloudPerformance\", \"params\": { } }," +
            "{ \"cell\": \"CellTrevis\", \"params\": { \"owner\": \"CocoaPods\", \"project\": \"CocoaPods\" } }," +
            "{ \"cell\": \"CellTeamCommits\", \"params\": { } }" +
        "]," +
        "[" +
            "{ \"cell\": \"CellDeployStatus\", \"params\": { } }," +
            "{ \"cell\": \"CellCommitsFeed\", \"params\": { } }" +
        "]" +
    "]",
    
    "[" +
        "[" +
            "{ \"cell\": \"CellPlaceholderWidthTwo\", \"params\": {} }," +
            "{ \"cell\": \"CellPlaceholderHeightTwo\", \"params\": {} }" +
        "]," +
        "[" +
            "{ \"cell\": \"CellPlaceholderTwoXTwo\", \"params\": {} }" +
        "]," +
        "[" +
            "{ \"cell\": \"CellPlaceholderSmall\", \"params\": { \"label\": \"macabeus é sayajin\" } }" +
        "]" +
    "]",
    
    "[" +
        "[" +
            "{ \"cell\": \"CellPlaceholderWidthTwo\", \"params\": {} }," +
            "{ \"cell\": \"CellPlaceholderHeightTwo\", \"params\": {} }" +
        "]," +
        "[" +
            "{ \"cell\": \"CellPlaceholderWidthTwo\", \"params\": {} }" +
        "]," +
        "[" +
            "{ \"cell\": \"CellPlaceholderSmall\", \"params\": { \"label\": \"macabeus sayajin\" } }," +
            "{ \"cell\": \"CellPlaceholderSmall\", \"params\": { \"label\": \"macabeus é lindo\" } }," +
            "{ \"cell\": \"CellPlaceholderSmall\", \"params\": { \"label\": \"macabeus é o galã\" } }" +
        "]" +
    "]"
]

struct Slot {
    var cell: SlotableCell
    var params: [String: Any]
}

class JSONConfig {
    
    let json: JSON // todo: talvez ser private?
    let slots: [[Slot]]
    
    init(rawConfig: String) {
        json = JSON(parseJSON: rawConfig)
        
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

class GridConfiguration {
    
    private var config: JSONConfig?
    let slots: [[Slot]]
    let gridConfigZoomOut: GridConfiguration?
    var isZoom: Bool {
        get {
            return self.gridConfigZoomOut != nil
        }
    }
    
    init(gridName: String) {
        // load config
        if gridName == "nothing" {
            config = JSONConfig(rawConfig: "[[]]")
            slots = [[]]
        } else {
            if gridName == "Blau" {
                config = JSONConfig(rawConfig: rawConfig[0])
            } else if gridName == "Save my nails" {
                config = JSONConfig(rawConfig: rawConfig[1])
            } else {
                config = JSONConfig(rawConfig: rawConfig[2])
            }
            slots = config!.slots
        }
        //
        
        self.gridConfigZoomOut = nil
    }
    
    init(zoomAtX x: Int, y: Int, grid: GridConfiguration) {
        let slot = grid.slots[y][x]
        slots = [[slot]]
        
        self.gridConfigZoomOut = grid
    }
}
