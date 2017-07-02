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
    case getDashboards()
    
    var path: String {
        switch self {
        case .userShortTokenLogin(_):
            return "/user/shorttoken/login"
        case .getDashboards():
            return "/user/dashboard"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .userShortTokenLogin(_):
            return .post
        case .getDashboards():
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .userShortTokenLogin(_):
            return nil
        case .getDashboards():
            return nil
        }
    }
    
    var needToken: Bool {
        switch self {
        case .userShortTokenLogin(_):
            return false
        case .getDashboards():
            return true
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .userShortTokenLogin(let token):
            return ["secret": token]
        case .getDashboards():
            return nil
        }
    }
    
    var dataType: ResponseType {
        switch self {
        case .userShortTokenLogin(_):
            return .json
        case .getDashboards():
            return .json
        }
    }
}
