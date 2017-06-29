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
    case userShortTokenLogin(_: String)
    
    var path: String {
        switch self {
        case .userShortTokenLogin(_):
            return "/user/shorttoken/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .userShortTokenLogin(_):
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .userShortTokenLogin(_):
            return nil
        }
    }
    
    var needToken: Bool {
        switch self {
        case .userShortTokenLogin(_):
            return false
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .userShortTokenLogin(let token):
            return ["secret": token]
        }
    }
    
    var dataType: ResponseType {
        switch self {
        case .userShortTokenLogin(_):
            return .json
        }
    }
}
