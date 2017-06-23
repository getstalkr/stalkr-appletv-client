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
 Struct for encapsulate a text message sent by websocket.
 The message is something like:
 {
     "type": "new_token",
     "data": {
         "token": "abc123"
     }
 }
 */
struct ResponseText {
    let type: String
    let data: [String: JSON]?
}

/**
 Protocol for that each websocket service need to subscriber
 */
protocol WebSocketChannel: WebSocketDelegate {
    associatedtype ChannelDelegate: BaseWebSocketDelegate
    
    /// Relative path of the endpoint we want to call (ie. /users/login)
    var path: String { get }
    
    /// You may also define a header to pass in this request
    var headers: [String: String] { get }
    
    //
    var socket: WebSocket! { get set }
    
    //
    var delegate: ChannelDelegate? { get set }
    
    //
    func didReceiveMessage(_ response: ResponseText)
    
    //
    init()
    
    init?(environment: Environment)
}
