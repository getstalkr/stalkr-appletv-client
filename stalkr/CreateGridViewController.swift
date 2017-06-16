//
//  CreateGridViewController.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 07/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import SwiftyJSON
import InputStepByStep
import AlertPro

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
        // todo: when show a alert, the focus gets weird
        
        ////
        // collected data from the InputStepyByStep
        guard let configGridName: String = inputValues["Dashboard"]!["projectName"] else {
            hrShowErrorAlert(withMessage: "Do you need set a name for your dashboard")
            return
        }
        // todo: need be flexible, for when a new cell is added we don't need update this code
        let configCellTravis: [String: String] = inputValues["Travis"]!
        let configCellTeamCommits: [String: String] = inputValues["Team Commits"]!
        let configCellCommitsFeed: [String:String] = inputValues["Commits Feed"]!
        let configCellCloudPerformance: [String:String] = inputValues["Cloud Performances"]!
        
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
        
        var cellCloudPerformance: String? = nil
        if configCellCloudPerformance.count == 3 {
            cellCloudPerformance = "" +
                "{" +
                    "\"cell\": \"CellCloudPerformance\"," +
                    "\"params\": {" +
                        "\"pusher_key\": \"\(configCellCloudPerformance["pusher_key"]!)\"," +
                        "\"stalkr_project\": \"\(configCellCloudPerformance["stalkr_project"]!)\"," +
                        "\"stalkr_team\": \"\(configCellCloudPerformance["stalkr_team"]!)\"" +
                    "}" +
                "}"
        }
        
        ////
        // join the data of cells in dashboard's JSON
        let firstRow: String?
        
        let firstRowArray = [cellCloudPerformance, cellTravis].flatMap({ $0 })
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
        UserSession.shared.addProject(json: json)
        hrShowAlert(withTitle: "Success", message: "New dashboard created!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueInputStepByStep" {
            self.container = (segue.destination as! InputStepByStep)
            self.container!.delegate = self
        }
    }

}
