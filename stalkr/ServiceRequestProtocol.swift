//
//  Request.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 19/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import Alamofire

/**
 Define the type of data we expect as response
 */
enum ResponseType {
    case json
}

/**
 Protocol for that each service request need to subscriber
 */
protocol ServiceRequest {
    
    /// Relative path of the endpoint we want to call (ie. /users/login)
    var path: String { get }
    
    /// Define the HTTP method we should use to perform the call
    var method: HTTPMethod { get }
    
    /// Parameters that we need to send along with the call
    var parameters: Parameters? { get }
    
    /// If this request need be executed with the user logged or not
    var needToken: Bool { get }
    
    /// You may also define a header to pass in this request
    var headers: HTTPHeaders? { get }
    
    /// What kind of data we expect as response
    var dataType: ResponseType { get }
}
