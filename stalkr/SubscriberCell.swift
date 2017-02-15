//
//  SubscriberCell.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 15/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation

protocol SubscriberCell {
    var webSocketHandles: [String: (_ data: Any?) -> Void] { get }
}

extension SubscriberCell {
    func getHandle(event: String) -> ((_ data: Any?) -> Void) {
        return self.webSocketHandles[event]!
    }
}
