//
//  StartWebSocket.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 20/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON
import Starscream

/**
 Protocol for that each websocket service need to subscriber
 */
protocol WebSocketProtocol {
    associatedtype MyDelegate
    
    /// Relative path of the endpoint we want to call (ie. /users/login)
    var path: String { get }
    
    /// You may also define a header to pass in this request
    var headers: [String: String] { get }
    
    //
    var socket: WebSocket { get }
    
    //
    var delegate: MyDelegate? { get set }
    
    //
    init?(environment: Environment)
}

struct ResponseText {
    let type: String
    let data: [String: JSON]?
}

extension WebSocketProtocol {
    /**
     First parse of one message received
     */
    func messageTextResponse(_ text: String) -> ResponseText {
        
        let json = JSON(parseJSON: text)
        let messageType = json["type"].stringValue
        let messageData = json["data"].dictionary
        
        return ResponseText(type: messageType, data: messageData)
    }
}
