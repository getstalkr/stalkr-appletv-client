//
//  DefaultsChannels.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 19/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import PromiseKit

fileprivate let environmentWebSocket = Environment(name: "local", host: "ws://127.0.0.1:13254")

fileprivate var environment: Environment = {
    if ProcessInfo.processInfo.arguments.contains("USE_LOCAL_USER_SERVER") {
        return Environment(name: "local", host: "http://127.0.0.1:8080")
    } else {
        return Environment(name: "production", host: "https://stalkr-cloud.herokuapp.com")
    }
}()

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
