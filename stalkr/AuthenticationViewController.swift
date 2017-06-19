//
//  AuthenticationViewController.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 16/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import Starscream
import SwiftyJSON

class AuthenticationViewController: UIViewController, WebSocketDelegate {

    var socket = WebSocket(url: URL(string: "ws://127.0.0.1:13254/")!)
    @IBOutlet weak var labelLoginKey: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket.headers["client-type"] = "tvOS" // todo: check if it's works
        socket.delegate = self
        
        socket.connect()
    }
    
    func websocketDidConnect(socket: WebSocket) {
        labelLoginKey.text = "getting key..."
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        labelLoginKey.text = "Error!! Websocket is disconnected!"
        print("Login's websocket is disconnected: \(error?.localizedDescription ?? "nil")")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
        let json = JSON(parseJSON: text)
        let messageType = json["type"].stringValue
        let messageData = json["data"].dictionaryValue
        
        if messageType == "login_key" {
            labelLoginKey.text = messageData["key_value"]!.stringValue
            
        } else if messageType == "login_success" {
            labelLoginKey.text = "logado! :3"
            
        }
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        // todo: it's never called!
        print("got some data: \(data.count)")
    }

}
