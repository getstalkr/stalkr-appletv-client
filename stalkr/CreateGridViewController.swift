//
//  CreateGridViewController.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 06/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import SwiftRichString
import SwiftyJSON

class CreateGridViewController: UICollectionViewController, CollectionStepByStepProtocol {

    var cellConfigList: [CellCreateGrid] = []
    var currentScene: UIFocusEnvironment?

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        if let scene = currentScene {
            return [scene]
        } else {
            return super.preferredFocusEnvironments
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        (collectionView! as! CollectionStepByStep).delegateStepByStep = self
        (collectionView! as! CollectionStepByStep).load()
        collectionView!.delegate = (collectionView! as! CollectionStepByStep)
        collectionView!.dataSource = (collectionView! as! CollectionStepByStep)
        
        //
        cellConfigList.append(CellCreateGrid.name("Dashboard"))
        cellConfigList.append(CellCreateGrid.input(ConfigInput(name: "projectName", label: "Name", inputType: .text, obligatory: true), cellName: "project", currentValue: ""))
        
        listAllSlotableCell.forEach { slotableCellClass in
            let configs = (slotableCellClass as! SlotableCell.Type).configurations
            if configs.count > 0 {
                let cellName = (slotableCellClass as! SlotableCell.Type).cellName
                
                cellConfigList.append(CellCreateGrid.name(cellName))
                configs.forEach { cellConfigList.append(CellCreateGrid.input($0, cellName: slotableCellClass.className(), currentValue: "")) }
            }
        }
        
        cellConfigList.append(CellCreateGrid.finish())
    }

    func cellFinishAction() {
        let inputs = cellConfigList.filter { Mirror(reflecting: $0).children.first?.label! == "input" }
        
        var configGridName: String = ""
        var configCellPlaceholderSmall: [String:String] = [:]
        var configlCellCloudPerformance: [String:String] = [:]
        var configlCellTrevis: [String:String] = [:]
        var configlCellTeamCommits: [String:String] = [:]
        var configlCellDeployStatus: [String:String] = [:]
        var configlCellCommitsFeed: [String:String] = [:]
        
        for case let .input(config, cellName, value) in inputs {
            // if config.obligatory && value == "" { ... // TODO: Se estiver faltando um parametro obrigatorio, algo deve ser feito
            
            switch cellName {
            case "project":
                configGridName = value
            case "CellPlaceholderSmall":
                configCellPlaceholderSmall[config.name] = value
            case "CellTrevis":
                configlCellTrevis[config.name] = value
            case "CellCommitsFeed":
                configlCellCommitsFeed[config.name] = value
            default:
                break
            }
        }
        
        // TODO: da feedback visual ao usuário
        let json = "" +
            "{" +
                "\"name\": \"\(configGridName)\"," +
                "\"grid\": [" +
                    "[" +
                        "{ \"cell\": \"CellCloudPerformance\", \"params\": { } }," +
                        "{ \"cell\": \"CellTrevis\", \"params\": { \"owner\": \"\(configlCellCommitsFeed["owner"]!)\", \"project\": \"\(configlCellCommitsFeed["project"]!)\" } }," +
                        "{ \"cell\": \"CellTeamCommits\", \"params\": { } }" +
                    "]," +
                    "[" +
                        "{ \"cell\": \"CellDeployStatus\", \"params\": { } }," +
                        "{ \"cell\": \"CellCommitsFeed\", \"params\": { \"owner\": \"\(configlCellCommitsFeed["owner"]!)\", \"project\": \"\(configlCellCommitsFeed["project"]!)\" } }" +
                    "]" +
                "]" +
            "}"
        
        // O código morto abaixo está mantido por ser útil na hora de debugar a parte de criar projeto, sem precisar preencher os campos
        /*let json = "{" +
            "\"name\": \"Project Test\"," +
            "\"grid\": [" +
                "[" +
                    "{ \"cell\": \"CellCloudPerformance\", \"params\": { } }," +
                    "{ \"cell\": \"CellTrevis\", \"params\": { \"owner\": \"ythecombinator\", \"project\": \"simple-add\" } }," +
                    "{ \"cell\": \"CellTeamCommits\", \"params\": { } }" +
                "]," +
                "[" +
                    "{ \"cell\": \"CellDeployStatus\", \"params\": { } }," +
                    "{ \"cell\": \"CellCommitsFeed\", \"params\": { \"owner\": \"ythecombinator\", \"project\": \"simple-add\" } }" +
                "]" +
            "]" +
         "}"*/
        
        UserSession.shared.addProject(project: Project(json: JSON(parseJSON: json)))
    }

}
