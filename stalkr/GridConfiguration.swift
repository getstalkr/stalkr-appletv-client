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
            "{ \"cell\": \"CellTrevis\", \"params\": { }, \"websocket\": { \"channel\": \"travis-builds-CocoaPods-CocoaPods\", \"event\": \"status-requested\" } }," +
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

struct WebSocketConfig {
    let channel: String
    let event: String
}

struct Slot {
    var cell: SlotableCell
    var params: [String: Any]
    var webSocketConfig: WebSocketConfig?
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
                
                // cell websocket config to subscriber
                let webSocketConfig: WebSocketConfig?
                if let webSocketJson = cell["websocket"].dictionary {
                    let channel = webSocketJson["channel"]!.stringValue
                    let event = webSocketJson["event"]!.stringValue

                    if !(cellObject.self is SubscriberCell) {
                        print("Erro de configuração no JSON: Há configuração de websocket para a célula do tipo \(cell["cell"].stringValue), porém, ela não está conforme o protocol SubscriberCell!")
                        webSocketConfig = nil
                        
                    } else if (cellObject as! SubscriberCell).webSocketHandles[event] == nil {
                        print("Erro de configuração no JSON: O handle para o event \(event) do channel \(channel) para a célula \(cell["cell"].stringValue) não foi implementado!")
                        webSocketConfig = nil
                        
                    } else {
                        webSocketConfig = WebSocketConfig(channel: channel, event: event)
                    }
                } else {
                    webSocketConfig = nil
                }
                
                //
                return Slot(cell: cellObject, params: params, webSocketConfig: webSocketConfig)
            }
        }
    }
}

class GridConfiguration {
    
    private var config: JSONConfig
    let slots: [[Slot]]
    
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
            slots = config.slots
        }
    }
    
    // todo: add cell
    // todo: remove cell
}
