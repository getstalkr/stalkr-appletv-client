//
//  WebSocketDelegate.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 21/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON
import Starscream

/**
 Enum used when receive a unexpected message by websocket
 */
enum WebSocketUnexpectedMessage {
    /// If this unexpected message is text
    case response(_: ResponseText)
    
    /// If this unexpected message is binnary
    case data(_: Data)
}

/**
 This protocol provibe basics functions for delegates of the websocket channels
 */
protocol BaseWebSocketDelegate: class {
    associatedtype EventEnum
    
    /// Called when the socket is connected
    func didConnect(socket: WebSocket)
    
    /// Called when the socket is disconnect
    func didDisconnect(socket: WebSocket, error: NSError?)
    
    /// Called always when receive a valid message
    func newMessage(socket: WebSocket, event: EventEnum)
    
    /// Called when one unexpected message is received.
    /// Some examples of situations is when receive a text message with "type" unknown, or "type" know but with "data" malformed
    func unexpectedMessage(socket: WebSocket, unexpectedMessage: WebSocketUnexpectedMessage)
}
