//
//  GetDashboardTask.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 01/07/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON
import GridView
import PromiseKit

enum GetDashboardTaskErros: Error, LocalizedError {
    case jsonMalformatted(String)
    
    public var errorDescription: String? {
        switch self {
        case .jsonMalformatted(let description):
            return "Dashboard json malformated: \(description)"
        }
    }
}

class GetDashboardTask: Task {
    
    var request: ServiceRequest {
        return UserService.getDashboards()
    }
    
    func execute(in dispatcher: Dispatcher) -> Promise<[Project]> {
        
        return self.execute(in: dispatcher) { response, fulfill, reject in
            switch response {
            
            case .json(let json):
                var projects: [Project] = []
                
                for project in json.arrayValue {
                    
                    // project name
                    guard let name = project.dictionaryValue["name"]?.string else {
                        reject(GetDashboardTaskErros.jsonMalformatted("Missing key \"name\""))
                        return
                    }
                    
                    // project slots
                    guard let gridArray = project.dictionaryValue["grid"]?.array else {
                        reject(GetDashboardTaskErros.jsonMalformatted("Missing key \"grid\""))
                        return
                    }

                    var slotsArray: [[(SlotableCell.Type, [String: Any])]] = []
                    
                    for rows in gridArray {
                        
                        var row: [(SlotableCell.Type, [String: Any])] = []
                        
                        for cell in rows.arrayValue {
                            let cellName = cell["cell"].stringValue
                            guard let cellClass = NSClassFromString("stalkr." + cellName) as? SlotableCell.Type else {
                                
                                reject(GetDashboardTaskErros.jsonMalformatted("\(cellName) is invalid cell class name"))
                                return
                            }
                            
                            guard let params = cell["params"].dictionaryObject else {
                                
                                reject(GetDashboardTaskErros.jsonMalformatted("Missing key \"params\""))
                                return
                            }
                            
                            row.append((cellClass, params))
                        }
                        
                        slotsArray.append(row)
                    }
                    
                    //
                    projects.append(Project(name: name, cells: slotsArray))
                }
                
                fulfill(projects)
                
            case .error(_, let error, _):
                reject(error)
            }
        }
    }
}
