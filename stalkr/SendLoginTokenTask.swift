//
//  SendLoginToken.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 19/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit

enum LoginTaskErros: Error {
    case incorrectToken
}

class LoginTask: Task {
    
    var loginToken: String
    
    init(loginToken: String) {
        self.loginToken = loginToken
    }
    
    var request: ServiceRequest {
        return UserService.sendLoginToken(loginToken)
    }
    
    func execute(in dispatcher: Dispatcher, with session: SessionContext) -> Promise<(userId: Int, sessionToken: String)> {
        
        return self.execute(in: dispatcher, with: session) { response, fulfill, reject in
            switch response {
            
            case .json(let json):
                let response = (userId: json["user_id"].intValue, sessionToken: json["session_token"].stringValue)
                fulfill(response)
                
            case .error(let httpErrorCode, let error, _):
                if httpErrorCode == 401 {
                    reject(LoginTaskErros.incorrectToken)
                } else {
                    reject(error)
                }
            }
        }
    }
}
