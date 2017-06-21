//
//  UserRequest.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 19/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import Alamofire

enum UserRequests: Request {
    case login(username: String, password: String)
    case getUsername()
    
    var path: String {
        switch self {
        case .login(_, _):
            return "/users/login"
        case .getUsername():
            return "/users/username"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login(_, _):
            return .post
        case .getUsername():
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let username, let password):
            return ["username": username, "password": password]
        case .getUsername():
            return nil
        }
    }
    
    var needToken: Bool {
        switch self {
        case .login(_, _):
            return false
        case .getUsername():
            return true
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
        case .login(_, _):
            return .json
        case .getUsername():
            return .json
        }
    }
}
