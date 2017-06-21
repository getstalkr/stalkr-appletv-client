//
//  SessionContext.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 20/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation

class SessionContext {
    private var state: SessionStates = .notLogged
    
    var isLogged: Bool {
        get {
            return state.isLogged
        }
    }
    
    var userId: Int? {
        get {
            return state.userId
        }
    }

    var userToken: String? {
        get {
            return state.userToken
        }
    }
    
    func changeStateToLogged(userId: Int, userToken: String) {
        state = .logged(userId: userId, userToken: userToken)
    }
    
    func changeStateToNotLogged() {
        state = .notLogged
    }
}

enum SessionStates {
    case notLogged
    case logged(userId: Int, userToken: String)
    
    var isLogged: Bool {
        switch self {
        case .notLogged:
            return false
        case .logged(_, _):
            return true
        }
    }
    
    var userId: Int? {
        switch self {
        case .notLogged:
            return nil
        case .logged(let userId, _):
            return userId
        }
    }
    
    var userToken: String? {
        switch self {
        case .notLogged:
            return nil
        case .logged(_, let userToken):
            return userToken
        }
    }
}
