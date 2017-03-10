//
//  UserSession.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 09/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserSession {
    static let shared = UserSession()
    private var projectsJson = [
        "{" +
            "\"name\": \"CocoaPods\"," +
            "\"grid\": [" +
                "[" +
                    "{ \"cell\": \"CellCloudPerformance\", \"params\": { } }," +
                    "{ \"cell\": \"CellTrevis\", \"params\": { \"owner\": \"CocoaPods\", \"project\": \"CocoaPods\" } }," +
                    "{ \"cell\": \"CellTeamCommits\", \"params\": { \"owner\": \"CocoaPods\", \"project\": \"CocoaPods\" } }" +
                "]," +
                "[" +
                    "{ \"cell\": \"CellDeployStatus\", \"params\": { } }," +
                    "{ \"cell\": \"CellCommitsFeed\", \"params\": { \"owner\": \"CocoaPods\", \"project\": \"CocoaPods\" } }" +
                "]" +
            "]" +
        "}",
        
        "{" +
            "\"name\": \"Jest\"," +
            "\"grid\": [" +
                "[" +
                    "{ \"cell\": \"CellCloudPerformance\", \"params\": { } }," +
                    "{ \"cell\": \"CellTrevis\", \"params\": { \"owner\": \"facebook\", \"project\": \"jest\" } }," +
                    "{ \"cell\": \"CellTeamCommits\", \"params\": { \"owner\": \"facebook\", \"project\": \"jest\" } }" +
                "]," +
                "[" +
                    "{ \"cell\": \"CellDeployStatus\", \"params\": { } }," +
                    "{ \"cell\": \"CellCommitsFeed\", \"params\": { \"owner\": \"facebook\", \"project\": \"jest\" } }" +
                "]" +
            "]" +
        "}"
    ]
    
    var projects: [Project]?
    
    init() {
        projects = projectsJson.map {
            Project(json: JSON(parseJSON: $0))
        }
    }
    
    func addProject(project: Project) {
        projects!.append(project)
    }

}
