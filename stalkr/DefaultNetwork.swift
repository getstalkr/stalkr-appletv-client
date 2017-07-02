//
//  DefaultsChannels.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 19/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import PromiseKit

// todo: see it https://stackoverflow.com/questions/38813906/swift-3-how-to-use-preprocessor-flags-like-if-debug-to-implement-api-keys

fileprivate let environmentWebSocket = Environment(name: "local", host: "ws://127.0.0.1:13254")

fileprivate let environment = Environment(name: "local", host: "http://127.0.0.1:8080")
fileprivate let serverDispatcher = ServerDispatcher(environment: environment)

extension Task {

    /// Execute the task in the default dispatcher with the global user session
    func execute() -> Promise<Output> {
        return self.execute(in: serverDispatcher)
    }
}

extension WebSocketChannel {
    
    init?() {
        self.init(environment: environmentWebSocket)
    }
}
