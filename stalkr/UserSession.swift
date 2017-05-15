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
                    "{" +
                        "\"cell\": \"CellCloudPerformance\"," +
                        "\"params\": {" +
                        "}" +
                    "}," +
                    "{" +
                        "\"cell\": \"CellTrevis\"," +
                        "\"params\": {" +
                            "\"pusher_key\": \"5cdc3c711f606f43aada\"," +
                            "\"owner\": \"CocoaPods\"," +
                            "\"project\": \"CocoaPods\"" +
                        "}" +
                    "}," +
                    "{" +
                        "\"cell\": \"CellTeamCommits\"," +
                        "\"params\": {" +
                            "\"pusher_key\": \"5cdc3c711f606f43aada\"," +
                            "\"owner\": \"CocoaPods\"," +
                            "\"project\": \"CocoaPods\"" +
                        "}" +
                    "}" +
                "]," +
                "[" +
                    "{" +
                        "\"cell\": \"CellDeployStatus\"," +
                        "\"params\": {" +
                        "}" +
                    "}," +
                    "{" +
                        "\"cell\": \"CellCommitsFeed\"," +
                        "\"params\": {" +
                            "\"pusher_key\": \"5cdc3c711f606f43aada\"," +
                            "\"owner\": \"CocoaPods\"," +
                            "\"project\": \"CocoaPods\"" +
                        "}" +
                    "}" +
                "]" +
            "]" +
        "}",
        
        "{" +
            "\"name\": \"Jest\"," +
            "\"grid\": [" +
                "[" +
                    "{" +
                        "\"cell\": \"CellCloudPerformance\"," +
                        "\"params\": {" +
                        "}" +
                    "}," +
                    "{" +
                        "\"cell\": \"CellTrevis\"," +
                        "\"params\": {" +
                            "\"pusher_key\": \"5cdc3c711f606f43aada\"," +
                            "\"owner\": \"facebook\"," +
                            "\"project\": \"jest\"" +
                        "}" +
                    "}," +
                    "{" +
                        "\"cell\": \"CellTeamCommits\"," +
                        "\"params\": {" +
                            "\"pusher_key\": \"5cdc3c711f606f43aada\"," +
                            "\"owner\": \"facebook\"," +
                            "\"project\": \"jest\"" +
                        "}" +
                    "}" +
                "]," +
                "[" +
                    "{" +
                        "\"cell\": \"CellDeployStatus\"," +
                        "\"params\": {" +
                        "}" +
                    "}," +
                    "{" +
                        "\"cell\": \"CellCommitsFeed\"," +
                        "\"params\": {" +
                            "\"pusher_key\": \"5cdc3c711f606f43aada\"," +
                            "\"owner\": \"facebook\"," +
                            "\"project\": \"jest\"" +
                        "}" +
                    "}" +
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
