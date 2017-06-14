//
//  TravisBuildRegister.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 16/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON

enum TravisSates {
    case running
    case success
    case failed
}

struct TravisBuildRegister {
    let number: String
    let branch: String
    let commit: String
    let authorName: String
    let message: String
    let eventType: String
    let dateStarted: Date?
    let dateFinish: Date?
    let state: TravisSates
    
    init(json: JSON) {
        let jsonBuild = json["build"].dictionaryValue
        let jsonCommit = json["commit"].dictionaryValue
        
        self.number = jsonBuild["number"]!.stringValue
        self.branch = jsonCommit["branch"]!.stringValue
        self.commit = jsonCommit["sha"]!.stringValue.substring(with: 0...7)
        self.message = jsonCommit["message"]!.stringValue
        if json["event_type"].stringValue == "pull_request" {
            self.eventType = "Pull Request"
        } else {
            self.eventType = "Push"
        }
        self.authorName = jsonBuild["authorName"]!.stringValue
        
        let statusMessage = jsonBuild["statusMessage"]!.stringValue
        if statusMessage == "Pending" {
            self.state = .running
        } else if statusMessage == "Passed" || statusMessage == "Fixed" {
            self.state = .success
        } else {
            self.state = .failed
        }
        
        if let startedAt = jsonBuild["startedAt"]?.string,
            let finishedAt = jsonBuild["finishedAt"]?.string {
            
            self.dateStarted = startedAt.toDate(format: "yyyy-MM-dd'T'HH:mm:ss'Z'")
            self.dateFinish = finishedAt.toDate(format: "yyyy-MM-dd'T'HH:mm:ss'Z'")
        } else {
            
            self.dateStarted = nil
            self.dateFinish = nil
        }
    }
}
