//
//  TravisBuildRegister.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 16/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TravisBuildRegister {
    let number: String
    let branch: String
    let commit: String
    let message: String
    let eventType: String
    let duration: Int
    let dateFinish: Date?
    
    init(json: JSON) {
        self.number = json["number"].stringValue
        self.branch = json["branch"].stringValue
        self.commit = json["commit"].stringValue
        self.message = json["message"].stringValue
        if json["event_type"].stringValue == "pull_request" {
            self.eventType = "Pull Request"
        } else {
            self.eventType = "Push"
        }
        self.duration = json["duration"].intValue
        
        let finishedAt = json["finished_at"].stringValue
        let index = finishedAt.index(finishedAt.startIndex, offsetBy: 10)
        self.dateFinish = finishedAt.substring(to: index).toDate(format: "yyyy-MM-dd")
    }
}
