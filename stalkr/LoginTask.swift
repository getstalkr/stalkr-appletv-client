//
//  LoginTask.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 19/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit

enum LoginTaskErros: Error {
    case incorrectCredentials
}

class LoginTask: Task {
    
    var username: String
    var password: String
    
    init(user: String, password: String) {
        self.username = user
        self.password = password
    }
    
    var request: Request {
        return UserRequests.login(username: self.username, password: self.password)
    }
    
    func execute(in dispatcher: Dispatcher, with session: SessionContext) -> Promise<(username: String, password: String)> {
        
        return self.execute(in: dispatcher, with: session) { response, fulfill, reject in
            switch response {
            
            case .json(let json):
                let myUser = (username: json["username"].stringValue, password: json["password"].stringValue)
                fulfill(myUser)
                
            case .error(let httpErrorCode, let error, _):
                if httpErrorCode == 401 {
                    reject(LoginTaskErros.incorrectCredentials)
                } else {
                    reject(error)
                }
            }
        }
    }
}
