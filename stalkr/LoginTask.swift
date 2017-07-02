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
        return UserService.userShortTokenLogin(loginToken)
    }
    
    func execute(in dispatcher: Dispatcher) -> Promise<(userId: Int, sessionToken: String)> {
        
        return self.execute(in: dispatcher) { response, fulfill, reject in
            switch response {
            
            case .json(let json):
                let response = (userId: json["user_id"].intValue, sessionToken: json["token"].stringValue)
                fulfill(response)
                
            case .error(let httpErrorCode, let error, _):
                if httpErrorCode == 500 {
                    reject(LoginTaskErros.incorrectToken)
                } else {
                    reject(error)
                }
            }
        }
    }
}
