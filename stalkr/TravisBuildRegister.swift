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
    let message: String
    let eventType: String
    let duration: Int
    let dateFinish: Date?
    let state: TravisSates
    
    init(json: JSON) {
        self.number = json["number"].stringValue
        self.branch = json["branch"].stringValue
        let commit = json["commit"].stringValue
        self.commit = commit.substring(to: commit.index(commit.startIndex, offsetBy: 7))
        self.message = json["message"].stringValue
        if json["event_type"].stringValue == "pull_request" {
            self.eventType = "Pull Request"
        } else {
            self.eventType = "Push"
        }
        self.duration = json["duration"].intValue
        
        if json["state"].stringValue == "created" || json["state"].stringValue == "started" {
            self.state = .running
        } else if json["result"].intValue == 0 {
            self.state = .success
        } else {
            self.state = .failed
        }
        
        let finishedAt = json["finished_at"].stringValue
        if finishedAt != "" {
            let index = finishedAt.index(finishedAt.startIndex, offsetBy: 10)
            self.dateFinish = finishedAt.substring(to: index).toDate(format: "yyyy-MM-dd")
        } else {
            self.dateFinish = nil
        }
    }
}
