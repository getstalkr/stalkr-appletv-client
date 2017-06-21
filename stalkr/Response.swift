//
//  Response.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 19/06/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ResponseError: Error, LocalizedError {
    case tokenMissing
    case invalidToken
    case internalError
    
    public var errorDescription: String? {
        switch self {
        case .tokenMissing:
            return "This request need a user token, but it's missing."
        case .invalidToken:
            return "Invalid token."
        case .internalError:
            return "Internal server error."
        }
    }
}

/**
 First parse of one request's response
 */
enum Response {
    // Possibles type of response for one request
    case json(_: JSON)
    case error(_: Int?, _: Error, _: Data?)
    
    //
    init(_ response: (r: HTTPURLResponse?, data: Data?, error: Error?), for request: Request) {
        // connections and internal erros of server
        if let error = response.error {
            self = .error(response.r?.statusCode, error, response.data)
            return
        } else if request.needToken && response.r?.statusCode == 401 {
            self = .error(response.r?.statusCode, ResponseError.invalidToken, response.data)
            return
        } else if let httpErrorCode = response.r?.statusCode,
            httpErrorCode < 200 || httpErrorCode > 299 {
            
            self = .error(response.r?.statusCode, ResponseError.internalError, response.data)
            return
        }
        
        // if haven't nothing error, parse the response data
        let data = response.data ?? Data()
        
        switch request.dataType {
        case .json:
            self = .json(JSON(data: data))
        }
    }
}
