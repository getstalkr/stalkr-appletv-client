//
//  UserSession.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 09/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation

class UserSession {
    static let shared = UserSession()
    
    var sessionContext = SessionContext()
    var projects: [Project] = []
    
    private init() {

    }
}
