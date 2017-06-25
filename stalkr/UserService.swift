//
//  UserRequest.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 19/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import Alamofire

enum UserService: ServiceRequest {
    case sendLoginToken(_: String)
    
    var path: String {
        switch self {
        case .sendLoginToken(_):
            return "/users/sendLoginToken"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sendLoginToken(_):
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .sendLoginToken(let token):
            return ["token": token]
        }
    }
    
    var needToken: Bool {
        switch self {
        case .sendLoginToken(_):
            return false
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default:
            return nil
        }
    }
    
    var dataType: ResponseType {
        switch self {
        case .sendLoginToken(_):
            return .json
        }
    }
}
