//
//  UserSession.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 09/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON // todo: in future, we need remove this "import" in this file, because UserSession shouldn't know JSON!!

class UserSession {
    static let shared = UserSession()
    private lazy var projectsJson: [String] = self.loadProjectsJson() ?? []
    // this dead code is keep because it's useful for test a full dashboard
    /*private var projectsJson = [
        "{" +
            "\"name\": \"My Little Test\"," +
            "\"grid\": [" +
                "[" +
                    "{" +
                        "\"cell\": \"CellTrevis\"," +
                        "\"params\": {" +
                            "\"pusher_key\": \"770713b7ff6732d20fb1\"," +
                            "\"stalkr_project\": \"testing-hooks\"," +
                            "\"stalkr_team\": \"ythecombinator\"" +
                        "}" +
                    "}," +
                    "{" +
                        "\"cell\": \"CellCommitsFeed\"," +
                        "\"params\": {" +
                            "\"pusher_key\": \"5cdc3c711f606f43aada\"," +
                            "\"stalkr_project\": \"testing-hooks\"," +
                            "\"stalkr_team\": \"ythecombinator\"" +
                        "}" +
                    "}" +
                "]" +
            "]" +
        "}",
        
        
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
                            "\"pusher_key\": \"770713b7ff6732d20fb1\"," +
                            "\"stalkr_project\": \"testing-hooks\"," +
                            "\"stalkr_team\": \"ythecombinator\"" +
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
                            "\"stalkr_project\": \"testing-hooks\"," +
                            "\"stalkr_team\": \"ythecombinator\"" +
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
                            "\"pusher_key\": \"770713b7ff6732d20fb1\"," +
                            "\"stalkr_project\": \"testing-hooks\"," +
                            "\"stalkr_team\": \"ythecombinator\"" +
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
                            "\"stalkr_project\": \"testing-hooks\"," +
                            "\"stalkr_team\": \"ythecombinator\"" +
                        "}" +
                    "}" +
                "]" +
            "]" +
        "}"
    ]*/
    
    var projects: [Project]?
    
    init() {
        projects = projectsJson.map {
            Project(json: JSON(parseJSON: $0))
        }
    }
    
    func addProject(json: String) {
        projectsJson.append(json)
        
        let project = Project(json: JSON(parseJSON: json))
        projects!.append(project)
        
        saveProjectsJson()
    }
    
    func saveProjectsJson() {
        let defaults = UserDefaults.standard
        defaults.set(projectsJson, forKey: "projectsJson")
    }

    func loadProjectsJson() -> [String]? {
        let defaults = UserDefaults.standard
        return defaults.stringArray(forKey: "projectsJson")
    }
}
