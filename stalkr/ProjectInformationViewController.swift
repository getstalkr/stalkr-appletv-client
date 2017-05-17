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
        ////
        // collected data from the InputStepyByStep
        guard let configGridName: String = inputValues["Dashboard"]!["projectName"] else {
            // todo: need show a visual feedback
            print("Do you need set a projectName")
            return
        }
        // todo: need be flexible, for when a new cell is added we don't need update this code
        let configCellTravis: [String: String] = inputValues["Travis"]!
        let configCellTeamCommits: [String: String] = inputValues["Team Commits"]!
        let configCellCommitsFeed: [String:String] = inputValues["Commits Feed"]!
        
        ////
        // convert config to JSON of a cell
        var cellTravis: String? = nil
        if configCellTravis.count == 3 {
            cellTravis = "" +
                "{" +
                    "\"cell\": \"CellTrevis\"," +
                    "\"params\": {" +
                        "\"pusher_key\": \"\(configCellTravis["pusher_key"]!)\"," +
                        "\"owner\": \"\(configCellTravis["owner"]!)\"," +
                        "\"project\": \"\(configCellTravis["project"]!)\"" +
                    "}" +
                "}"
        }

        var cellTeamCommits: String? = nil
        if configCellTeamCommits.count == 3 {
            cellTeamCommits = "" +
                "{" +
                    "\"cell\": \"CellTeamCommits\"," +
                    "\"params\": {" +
                        "\"pusher_key\": \"\(configCellTeamCommits["pusher_key"]!)\"," +
                        "\"owner\": \"\(configCellTeamCommits["owner"]!)\"," +
                        "\"project\": \"\(configCellTeamCommits["project"]!)\"" +
                    "}" +
                "}"
        }
        
        var cellCommitsFeed: String? = nil
        if configCellCommitsFeed.count == 3 {
            cellCommitsFeed = "" +
                "{" +
                    "\"cell\": \"CellCommitsFeed\"," +
                    "\"params\": {" +
                        "\"pusher_key\": \"\(configCellCommitsFeed["pusher_key"]!)\"," +
                        "\"owner\": \"\(configCellCommitsFeed["owner"]!)\"," +
                        "\"project\": \"\(configCellCommitsFeed["project"]!)\"" +
                    "}" +
                "}"
        }
        
        ////
        // join the data of cells in dashboard's JSON
        let firstRow: String?
        
        let firstRowArray = [cellTravis, cellTeamCommits].flatMap({ $0 })
        if firstRowArray.count == 0 {
            firstRow = nil
        } else {
            firstRow = firstRowArray.joined(separator: ",")
        }
        
        let secondRow = cellCommitsFeed
        
        let grid = "[" +
                [firstRow, secondRow].flatMap({ $0 }).flatMap({ "[\($0)]" }).joined(separator: ",") +
            "]"
        
        let json = "" +
            "{" +
                "\"name\": \"\(configGridName)\"," +
                "\"grid\": \(grid)" +
            "}"
        
        ////
        // save
        // TODO: need show a visual feedback when is saved
        UserSession.shared.addProject(project: Project(json: JSON(parseJSON: json)))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueInputStepByStep" {
            self.container = (segue.destination as! InputStepByStep)
            self.container!.delegate = self
        }
    }

}
