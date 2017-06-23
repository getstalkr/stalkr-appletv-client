//
//  ExecuteWebSocket.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 20/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON
import Starscream

/**
 Possibles events when receive a new message in login channel
 */
enum LoginWebSocketEvents {
    case newKey(_: String?)
    case authenticationSuccess
    case authenticationFail
}

protocol LoginWebSocketDelegate: BaseWebSocketDelegate {
    func newMessage(socket: WebSocket, event: LoginWebSocketEvents)
}

final class LoginWebSocketChannel<D: LoginWebSocketDelegate>: WebSocketChannel {
    
    let path = ""
    let headers = ["client-type": "tvOS"]
    var socket: WebSocket!
    
    typealias ChannelDelegate = D
    weak var delegate: D?
    
    func didReceiveMessage(_ response: ResponseText) {
        switch response.type {
        case "new_key":
            let newKeyValue = response.data?["key"]?.stringValue
            delegate?.newMessage(socket: socket, event: .newKey(newKeyValue))
            
        case "authentication_success":
            delegate?.newMessage(socket: socket, event: .authenticationSuccess)
            
        case "authentication_fail":
            delegate?.newMessage(socket: socket, event: .authenticationFail)
            
        default:
            // we don't expect that will receive a response type different from above
            delegate?.unexpectedMessage(socket: socket, unexpectedMessage: .response(response))
        }
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        // we don't expect that will receive a binnary data in this channel
        delegate?.unexpectedMessage(socket: socket, unexpectedMessage: .data(data))
    }
}
