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

enum WebSocketUnexpectedMessage {
    case response(_: ResponseText)
    case data(_: Data)
}

protocol BaseWebSocketDelegate: class {
    associatedtype EventEnum
    
    /// Called when the socket is connected
    func didConnect(socket: WebSocket)
    
    /// Called when the socket is disconnect
    func didDisconnect(socket: WebSocket, error: NSError?)
    
    ////
    func newMessage(socket: WebSocket, event: EventEnum)
    
    /// Called when one unexpected message is received
    func unexpectedMessage(socket: WebSocket, unexpectedMessage: WebSocketUnexpectedMessage)
}
