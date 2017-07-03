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
    case checkTokenValid(_: String)
    case getDashboards()
    
    var path: String {
        switch self {
        case .userShortTokenLogin(_):
            return "/user/shorttoken/login"
        case .checkTokenValid(_):
            return "/user/me"
        case .getDashboards():
            return "/user/dashboards"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .userShortTokenLogin(_):
            return .post
        case .checkTokenValid(_):
            return .get
        case .getDashboards():
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .userShortTokenLogin(_):
            return nil
        case .checkTokenValid(_):
            return nil
        case .getDashboards():
            return nil
        }
    }
    
    var needToken: Bool {
        switch self {
        case .userShortTokenLogin(_):
            return false
        case .checkTokenValid(_):
            return false
        case .getDashboards():
            return true
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .userShortTokenLogin(let token):
            return ["secret": token]
        case .checkTokenValid(let token):
            return ["Authorization": "Bearer \(token)"]
        case .getDashboards():
            return nil
        }
    }
    
    var dataType: ResponseType {
        switch self {
        case .userShortTokenLogin(_):
            return .json
        case .checkTokenValid(_):
            return .json
        case .getDashboards():
            return .json
        }
    }
}
