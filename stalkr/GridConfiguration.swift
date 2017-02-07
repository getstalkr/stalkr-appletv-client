//
//  GridConfiguration.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 01/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Slot {
    var cell: SlotableCell
    var params: [String: Any]
}

class JSONConfig {
    
    let rawConfig: String // todo: talvez ser private?
    let json: JSON // todo: talvez ser private?
    let slots: [[Slot]]
    
    init() {
        // todo: o valor de rawConfig precisa ser provido a partir de uma fonte externa!
        /*rawConfig = "" +
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
            "]"*/
        
        rawConfig = "" +
            "[" +
                "[" +
                    "{ \"cell\": \"CellPlaceholderWidthTwo\", \"params\": {} }," +
                    "{ \"cell\": \"CellPlaceholderHeightTwo\", \"params\": {} }" +
                "]," +
                "[" +
                    "{ \"cell\": \"CellPlaceholderWidthTwo\", \"params\": {} }" +
                "]," +
                "[" +
                    "{ \"cell\": \"CellPlaceholderSmall\", \"params\": { \"label\": \"macabeus é sayajin\" } }," +
                    "{ \"cell\": \"CellPlaceholderSmall\", \"params\": { \"label\": \"macabeus é lindo\" } }," +
                    "{ \"cell\": \"CellPlaceholderSmall\", \"params\": { \"label\": \"macabeus é o galã\" } }" +
                "]" +
            "]"
        
        json = JSON(parseJSON: rawConfig)
        
        slots = json.arrayValue.map { rows -> [Slot] in
            rows.arrayValue.map { cell -> Slot in
                let cellClass = NSClassFromString("stalkr." + cell["cell"].stringValue)! as! NSObject.Type
                let cellObject = cellClass.init() as! SlotableCell
                let params = cell["params"].dictionaryObject!
                
                return Slot(cell: cellObject, params: params)
            }
        }
    }
}

class GridConfiguration {
    
    static let shared = GridConfiguration()
    let slots: [[Slot]]
    var config: JSONConfig
    
    private init() {
        // load config
        config = JSONConfig()
        slots = config.slots
    }
    
    // todo: add cell
    // todo: remove cell
}
