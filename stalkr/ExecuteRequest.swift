//
//  ExecuteRequest.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 19/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import PromiseKit

/**
 The dispatcher is responsible to execute a Request by calling the underlyning layer.
 As output for a Request it should provide a Response.
 */
protocol Dispatcher {
    
    /// Configure the dispatcher with an environment
    ///
    /// - Parameter environment: environment configuration
    init(environment: Environment)
    
    /// This function execute the request and provide a Promise with the response.
    ///
    /// - Parameter request: request to execute
    /// - Parameter session: in whitch user session this request will be executed
    /// - Returns: promise
    func execute(request: ServiceRequest) -> Promise<Response>
}
