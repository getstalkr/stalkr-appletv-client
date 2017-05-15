//
//  SubscriberCell.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 15/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON
import PusherSwift
import Alamofire
import GridView

struct WebSocketConfig {
    let requestStartUrl: String
    let requestStartParams: ([String: Any]) -> [String: String]
    let channel: ([String: Any]) -> String
    let event: String
}

protocol SubscriberCell {
    var pusher: Pusher? { get set } // todo: we need uncouple Pusher in SubscriberCell protocol
    
    var webSockets: [WebSocketConfig] { get }
    var webSocketHandles: [String: (_ data: JSON, _ cell: SlotableCell) -> Void] { get }
}

extension SubscriberCell {
    func getHandle(event: String, cell: SlotableCell) -> ((_ data: JSON, _ cell: SlotableCell) -> Void) {
        return self.webSocketHandles[event]!
    }
    
    func subscriber(pusherKey: String, params: [String: Any]) -> Pusher {
        let pusher = Pusher(key: pusherKey)
        
        self.webSockets.forEach { webSocket in
            
            // subscribe in channel
            let channelName = webSocket.channel(params)
            let channel = pusher.subscribe(channelName)
            
            // function to converter data "Any?" to "JSON", and pass the current cell
            func wrapper(data: Any?) {
                let json: JSON
                if let object = data as? [String : Any],
                    let jsonData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) {
                    json = JSON(data: jsonData)
                } else {
                    json = JSON(arrayLiteral: [])
                }
                
                if let loading = self as? LoadingViewProtocol {
                    loading.loadingView.stop()
                }
                self.getHandle(event: webSocket.event, cell: self as! SlotableCell)(json, self as! SlotableCell)
            }
            
            let _ = channel.bind(eventName: webSocket.event, callback: wrapper)
            
            pusher.connect()
            
            // start websocket on server
            if let loading = self as? LoadingViewProtocol {
                loading.loadingView.show(message: "Fetching data...")
            }
            
            Alamofire.request(
                webSocket.requestStartUrl,
                method: .post,
                parameters: webSocket.requestStartParams(params),
                encoding: JSONEncoding.default,
                headers: ["Content-Type": "application/json"]
            ).responseJSON { response in
                let statusCode = (response.response?.statusCode)!
                
                if statusCode != 200,
                    let loading = self as? LoadingViewProtocol {
                    
                    loading.loadingView.error(message: "Something went wrong.\nCheck your connection and reload the app.")
                }
            }
        }
        
        return pusher
    }
}
