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
    
    // Store session
    func store() {
        let defaults = UserDefaults.standard
        defaults.set(userToken, forKey: "sessionToken")
    }
    
    func recover() -> Bool {
        // recover token
        // todo: check if the token recovered still is valid
        let defaults = UserDefaults.standard
        guard let sessionToken = defaults.string(forKey: "sessionToken") else {
            return false
        }
        
        // set session
        self.changeStateToLogged(userToken: sessionToken)
        
        //
        return true
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
