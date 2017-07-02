//
//  ServerDispatcher.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 19/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class ServerDispatcher: Dispatcher {
    
    private var environment: Environment
    
    required init(environment: Environment) {
        self.environment = environment
    }
    
    func execute(request: ServiceRequest) -> Promise<Response> {
        let requestUrl = prepareURLRequest(for: request)
        
        return Promise { fulfill, reject in
            
            var headers: HTTPHeaders?
            if request.needToken {
                if UserSession.shared.sessionContext.isLogged == false {
                    reject(ResponseError.tokenMissing)
                    return
                }
                
                headers = (request.headers ?? [:])
                headers!["Authorization"] = "Bearer \(UserSession.shared.sessionContext.userToken!)"
            } else {
                headers = request.headers
            }
        
            switch request.dataType {
            case .json:
                Alamofire.request(
                    requestUrl,
                    method: request.method,
                    parameters: request.parameters,
                    encoding: JSONEncoding.default,
                    headers: headers
                ).responseJSON(completionHandler: { response in
                        
                    let resp = Response((r: response.response, data: response.data, error: response.error), for: request)
                        
                    switch resp {
                    case .error(_, ResponseError.internalError, _):
                        fulfill(resp) // internal erros need be resolved by task
                        
                    case .error(_, let error, _):
                        reject(error) // server erros (for example, no connection)
                        
                    default:
                        fulfill(resp) // success
                    }
                })
            }
        }
    }
    
    private func prepareURLRequest(for request: ServiceRequest) -> URL {
        return URL(string: "\(self.environment.host)\(request.path)")!
    }
}
