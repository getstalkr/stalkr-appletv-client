//
//  CommitRegister.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 03/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CommitRegister {
    let name: String
    let imageUrl: String?
    let message: String
    let branch: String
    let sha: String
    let date: Date
        
    init(json: JSON) {
        self.name = json["author"].dictionaryValue["name"]!.stringValue
        
        self.imageUrl = json["author"].dictionaryValue["avatar"]?.stringValue
        
        self.message = json["commit"].dictionaryValue["message"]!.stringValue
        
        let branch = json["commit"].dictionaryValue["branch"]!.stringValue
        self.branch = branch.substring(to: branch.index(branch.startIndex, offsetBy: 7))
        
        let sha = json["commit"].dictionaryValue["sha"]!.stringValue
        self.sha = sha.substring(with: 0...7)
        
        let dateString = json["commit"].dictionaryValue["date"]!.stringValue
        self.date = dateString.substring(with: 0...19).toDate(format: "yyyy-MM-dd'T'HH:mm:ss")!
    }
}
