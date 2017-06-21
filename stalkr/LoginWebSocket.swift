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

enum LoginWebSocketEvents {
    case newKey(_: String?)
    case authenticationSuccess
    case authenticationFail
}

protocol LoginWebSocketDelegate: BaseWebSocketDelegate {
    func loginNewMessage(socket: WebSocket, event: LoginWebSocketEvents)
}

class LoginWebSocket: WebSocketProtocol, WebSocketDelegate {
    
    let path = ""
    let headers = ["client-type": "tvOS"]
    let socket: WebSocket
    
    weak var delegate: LoginWebSocketDelegate?
    typealias MyDelegate = LoginWebSocketDelegate
    
    required init?(environment: Environment) {
        // todo: when we migrate to Swift4, move this code of init to one extension
        guard let url = URL(string: "\(environment.host)/\(path)") else {
            return nil
        }
        
        socket = WebSocket(url: url)
        socket.delegate = self
    }
    
    func websocketDidConnect(socket: WebSocket) {
        delegate?.didConnect(socket: socket)
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        delegate?.didDisconnect(socket: socket, error: error)
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
        let response = messageTextResponse(text)
        
        switch response.type {
        case "new_key":
            let newKeyValue = response.data?["key"]?.stringValue
            delegate?.loginNewMessage(socket: socket, event: .newKey(newKeyValue))
            
        case "authentication_success":
            delegate?.loginNewMessage(socket: socket, event: .authenticationSuccess)
            
        case "authentication_fail":
            delegate?.loginNewMessage(socket: socket, event: .authenticationFail)
            
        default:
            // we don't expect that will receive a response type different from above
            delegate?.unexpectedMessage(socket: socket, unexpectedMessage: .response(response))
        }
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        // we don't expect that will receive "data" from websocket of login
        delegate?.unexpectedMessage(socket: socket, unexpectedMessage: .data(data))
    }
}
