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
import GridView

// todo: we need uncouple Pusher in Stalkr

struct WebSocketConfig {
    let channel: ([String: Any]) -> String
    let event: String
    let handle: (_ data: JSON, _ cell: SlotableCell) -> Void
}

protocol SubscriberCell {
    var pusher: Pusher? { get set }
    
    var webSockets: [WebSocketConfig] { get }
}

extension SubscriberCell {
    
    func subscriber(pusherKey: String, params: [String: Any]) -> Pusher {
        let pusher = Pusher(key: pusherKey)
        
        // return a function to wrapper the handle
        func wrapperHandle(_ handle: @escaping (_ data: JSON, _ cell: SlotableCell) -> Void) -> ((Any?) -> Void) {
            
            return { (data: Any?) -> () in
                // converter parameter "Any?" to "JSON", and pass the current cell
                let json: JSON
                
                if let object = data as? [String : Any],
                    let jsonData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) {
                    json = JSON(data: jsonData)
                } else {
                    json = JSON(arrayLiteral: [])
                }
                
                // stop the loading animation, if need
                if let cellLoading = self as? LoadingAnimateCellProtocol,
                    cellLoading.loading.currentState == .waiting {
                    
                    cellLoading.loading.stop()
                }

                // call handle function
                handle(json, self as! SlotableCell)
            }
        }
        
        self.webSockets.forEach { webSocket in
            
            // subscribe in channel
            let channelName = webSocket.channel(params)
            let channel = pusher.subscribe(channelName)
            
            // bind
            let _ = channel.bind(eventName: webSocket.event, callback: wrapperHandle(webSocket.handle))
        }
        
        pusher.connect()
        
        return pusher
    }
}
