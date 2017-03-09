//
//  Project.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 09/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import SwiftyJSON

class Project {
    let name: String
    let grid: GridConfiguration
    
    init(json: JSON) {
        self.name = json.dictionaryValue["name"]!.stringValue
        self.grid = GridConfiguration(json: json.dictionaryValue["grid"]!)
    }
    
    func show(atProjectView projectView: ProjectViewProtocol) {
        projectView.didChangeProject(self)
    }
}
