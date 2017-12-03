//
//  Task.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 19/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import PromiseKit

protocol Task {
    associatedtype Output
    
    /// Request to execute
    var request: ServiceRequest { get }
    
    /// Execute request in passed dispatcher
    ///
    /// - Parameter dispatcher: dispatcher
    /// - Parameter session: in whitch user session this request will be executed
    /// - Returns: a promise
    func execute(in dispatcher: Dispatcher) -> Promise<Output>
}

extension Task {
    func execute(in dispatcher: Dispatcher, then handle: @escaping (Response, @escaping (Output) -> Void, @escaping (Error) -> Void) -> Void) -> Promise<Output> {
        
        return Promise { fulfill, reject in
            firstly {
                dispatcher.execute(request: request)
            }.then { response -> Void in
                handle(response, fulfill, reject)
            }.catch { error in
                reject(error)
            }
        }
    }
}
