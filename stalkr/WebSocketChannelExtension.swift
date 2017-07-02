//
//  WebSocketExtension.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 22/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON
import Starscream

extension WebSocketChannel {
    
    init?(environment: Environment) {
        self.init()
        
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
    
    /**
     First parse of one message received
     */
    func messageTextResponse(_ text: String) -> ResponseText? {
        
        let json = JSON(parseJSON: text)
        guard let messageType = json["type"].string else {
            return nil
        }
        let messageData = json["data"].dictionary
        
        return ResponseText(type: messageType, data: messageData)
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        guard let response = messageTextResponse(text) else {
            delegate?.unexpectedMessage(socket: socket, unexpectedMessage: .textMalformed(text))
            return
        }
        
        self.didReceiveMessage(response)
    }
}
