//
//  MeTask.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 02/07/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import PromiseKit

class MeTask: Task {
    
    var request: ServiceRequest {
        return UserService.me()
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
