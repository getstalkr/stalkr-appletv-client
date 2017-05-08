//
//  ProjectInformationViewController.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 07/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import SwiftyJSON
import InputStepByStep

class CreateGridViewController: UIViewController, InputStepByStepProtocol {

    @IBOutlet weak var container: InputStepByStep!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.cornerRadius = 15
    }

    var configList: [CellCreateGrid] = {
        var configList: [CellCreateGrid] = []
        configList.append(.name("Dashboard"))
        configList.append(.input(name: "projectName", label: "Name"))
        
        listAllSlotableCell.forEach { slotableCell in
            guard let cell = slotableCell.classObject as? StalkrCell.Type else {
                return
            }
                
            let configs = cell.configurations
            if configs.count > 0 {
                let cellName = cell.cellName
                    
                configList.append(.name(cellName))
                configs.forEach {
                    configList.append(.input(name: $0.name, label: $0.label))
                }
            }
        }
        
        configList.append(.finish())
        
        return configList
    }()
    
    func cellFinishAction(inputValues: [String: [String: String]]) {
        let configGridName: String = inputValues["Dashboard"]!["projectName"]!
        let configlCellTrevis: [String: String] = inputValues["Travis"]!
        var configlCellTeamCommits: [String: String] = inputValues["Team Commits"]!
        var configlCellCommitsFeed: [String:String] = inputValues["Commits Feed"]!
        
        let json = "" +
            "{" +
                "\"name\": \"\(configGridName)\"," +
                "\"grid\": [" +
                    "[" +
                        "{ \"cell\": \"CellCloudPerformance\", \"params\": { } }," +
                        "{ \"cell\": \"CellTrevis\", \"params\": { \"owner\": \"\(configlCellTrevis["owner"]!)\", \"project\": \"\(configlCellTrevis["project"]!)\" } }," +
                        "{ \"cell\": \"CellTeamCommits\", \"params\": { \"owner\": \"\(configlCellTeamCommits["owner"]!)\", \"project\": \"\(configlCellTeamCommits["project"]!)\" } }" +
                    "]," +
                    "[" +
                        "{ \"cell\": \"CellDeployStatus\", \"params\": { } }," +
                        "{ \"cell\": \"CellCommitsFeed\", \"params\": { \"owner\": \"\(configlCellCommitsFeed["owner"]!)\", \"project\": \"\(configlCellCommitsFeed["project"]!)\" } }" +
                    "]" +
                "]" +
            "}"
        
        // TODO: da feedback visual ao usuário quando salvar
        UserSession.shared.addProject(project: Project(json: JSON(parseJSON: json)))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueInputStepByStep" {
            self.container = (segue.destination as! InputStepByStep)
            self.container!.delegate = self
        }
    }
}
