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

import PromiseKit

class AuthenticationViewController: UIViewController, LoginWebSocketDelegate {

    let environment = Environment(name: "local", host: "ws://127.0.0.1:13254")
    var loginChannel: LoginWebSocketChannel<AuthenticationViewController>?
    @IBOutlet weak var labelLoginKey: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*globalUserSession.changeStateToLogged(userId: 1, userToken: "abc123")
      
        firstly {
            GetUsernameTask().execute()
        }.then { r -> Void in
            print(r)
        }.catch { error in
            print("erro: \(error.localizedDescription)")
        }*/
        
        /*firstly {
            LoginTask(user: "macabeus", password: "1245325345334").execute()
        }.then { r -> Void in
            print("meu usuario: \(r)")
        }.catch { error in
            
            if let error = error as? LoginTaskErros {
                switch error {
                case .incorrectCredentials:
                    print("credenciais incorretas")
                }
            
            } else {
                print("erro: \(error.localizedDescription)")
            }
        }*/
        
        loginChannel = LoginWebSocketChannel<AuthenticationViewController>(environment: environment)
        loginChannel!.delegate = self
        loginChannel!.socket.connect()
    }
    
    func didConnect(socket: WebSocket) {
        labelLoginKey.text = "getting key..."
    }
    
    func didDisconnect(socket: WebSocket, error: NSError?) {
        labelLoginKey.text = "ERROR: Websocket is disconnected!"
        print("WARNING: Login's websocket is disconnected: \(error?.localizedDescription ?? "nil")")
    }
    
    func newMessage(socket: WebSocket, event: LoginWebSocketEvents) {
        
        switch event {
        case .newKey(let key):
            labelLoginKey.text = key
        case .authenticationSuccess:
            labelLoginKey.text = "logado! :3"
        case .authenticationFail:
            labelLoginKey.text = "fail =["
        }
    }
    
    func unexpectedMessage(socket: WebSocket, unexpectedMessage: WebSocketUnexpectedMessage) {
        print("WARNING: Unexpected message received in socket!")
    }

}
