//
//  GetUsernameTask.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 20/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit

class GetUsernameTask: Task {
    
    var request: Request {
        return UserRequests.getUsername()
    }
    
    func execute(in dispatcher: Dispatcher, with session: SessionContext) -> Promise<String> {
        
        return self.execute(in: dispatcher, with: session) { response, fulfill, reject in
            switch response {
            
            case .json(let json):
                fulfill(json.stringValue)
            
            case .error(_, let error, _):
                reject(error)
            }
        }
    }
}
