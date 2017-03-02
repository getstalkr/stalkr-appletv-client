//
//  SubscriberCell.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 15/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON

struct WebSocketConfig {
    let requestStartUrl: String
    let requestStartParams: ([String: Any]) -> [String: String]
    let channel: ([String: Any]) -> String
    let event: String
}

protocol SubscriberCell {
    var webSockets: [WebSocketConfig] { get }
    var webSocketHandles: [String: (_ data: JSON, _ cell: SlotableCell) -> Void] { get }
}

extension SubscriberCell {
    func getHandle(event: String, cell: SlotableCell) -> ((_ data: JSON, _ cell: SlotableCell) -> Void) {
        return self.webSocketHandles[event]!
    }
}
