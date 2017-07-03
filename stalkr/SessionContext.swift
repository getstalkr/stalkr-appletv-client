//
//  SessionContext.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 20/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import PromiseKit

enum RecorverTokenErrors: Error {
    case haveNotFileWithLastToken
    case sessionExpired
}

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
    
    func changeStateToLogged(sessionToken: String, storeToken: Bool) {
        state = .logged(userToken: sessionToken)
        
        if storeToken {
            store()
        }
    }
    
    func changeStateToNotLogged(removeTokenStored: Bool) {
        state = .notLogged
        
        if removeTokenStored {
            removeStored()
        }
    }
    
    // Store session
    private func store() {
        let defaults = UserDefaults.standard
        defaults.set(userToken, forKey: "sessionToken")
    }
    
    private func removeStored() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "sessionToken")
    }
    
    func recoverToken() -> Promise<String> {
        return Promise { fulfill, reject in
            let defaults = UserDefaults.standard
            guard let sessionToken = defaults.string(forKey: "sessionToken") else {
                reject(RecorverTokenErrors.haveNotFileWithLastToken)
                return
            }
            
            firstly {
                CheckTokenValidTask(sessionToken).execute()
            }.then {
                fulfill(sessionToken)
            }.catch { _ in
                reject(RecorverTokenErrors.sessionExpired)
            }
        }
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
