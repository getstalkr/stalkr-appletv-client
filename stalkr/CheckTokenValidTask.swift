//
//  CheckTokenValidTask.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 02/07/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import PromiseKit

class CheckTokenValidTask: Task {
    
    var sessionToken: String
    
    init(_ sessionToken: String) {
        self.sessionToken = sessionToken
    }
    
    var request: ServiceRequest {
        return UserService.checkTokenValid(sessionToken)
    }
    
    func execute(in dispatcher: Dispatcher) -> Promise<Void> {
        
        return self.execute(in: dispatcher) { response, fulfill, reject in
            switch response {
                
            case .json(_):
                fulfill()
                
            case .error(_, let error, _):
                reject(error)
            }
        }
    }
}
