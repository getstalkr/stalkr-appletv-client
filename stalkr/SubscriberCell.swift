//
//  SubscriberCell.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 15/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol SubscriberCell {
    var webSocketHandles: [String: (_ data: JSON, _ cell: SlotableCell) -> Void] { get }
}

extension SubscriberCell {
    func getHandle(event: String, cell: SlotableCell) -> ((_ data: JSON, _ cell: SlotableCell) -> Void) {
        return self.webSocketHandles[event]!
    }
}
