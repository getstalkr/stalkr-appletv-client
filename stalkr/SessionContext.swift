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

    var userToken: String? {
        get {
            return state.userToken
        }
    }
    
    func changeStateToLogged(userToken: String) {
        state = .logged(userToken: userToken)
    }
    
    func changeStateToNotLogged() {
        state = .notLogged
    }
}

enum SessionStates {
    case notLogged
    case logged(userToken: String)
    
    var isLogged: Bool {
        switch self {
        case .notLogged:
            return false
        case .logged(_):
            return true
        }
    }
    
    var userToken: String? {
        switch self {
        case .notLogged:
            return nil
        case .logged(let userToken):
            return userToken
        }
    }
}
