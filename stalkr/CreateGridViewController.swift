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

enum CellCreateGrid {
    case name(String)
    case input(ConfigInput, cellName: String, currentValue: String)
    case finish()
}

class CreateGridViewController: UICollectionViewController {

    var cellConfigList: [CellCreateGrid] = []
    var lastCellConfigSelected = IndexPath(row: 1, section: 0)
    var currentScene: UIFocusEnvironment?
    let showInput = ShowInput()
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        if let scene = currentScene {
            return [scene]
        } else {
            return super.preferredFocusEnvironments
        }
    }
   
    // load
    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionView?.collectionViewLayout as? CollectionStepByStepLayout {
            layout.delegate = self
        }
        
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cellConfigList.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch cellConfigList[section] {
        case .name(_):
            return 2
        default:
            return 1
        }
    }

    // show cells
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentCell = cellConfigList[indexPath.section]
        
        if Mirror(reflecting: currentCell).children.first?.label! == "name" && indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellDivision", for: indexPath) as! CellConfigDivision
            
            cell.startCell()
            
            return cell
        }
        
        switch currentCell {
        case .name(let name):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellConfigTitle", for: indexPath) as! CellConfigTitle
            
            cell.labelTitle.text = name
            
            return cell
        case .input(let input, _, let value):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellConfigInput", for: indexPath) as! CellConfigInput
            // if input.obligatory { ... // TODO: Colocar na UI algo para diferenciar quando o campo é obrigatório/opcional
            
            if value == "" {
                cell.labelField.text = input.label
            } else {
                cell.labelField.text = value
            }
            
            return cell
        case .finish:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellConfigFinish", for: indexPath) as! CellConfigFinish
            
            cell.startCell()
            
            return cell
        }
    }
    
    // focus
    override func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    // input
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if let cell = cell as? CellConfigInput {
            showInput.callback = { text in
                // TODO: é preciso atualizar o status de "cheio" e "vazio" daquela bolinha da cell step
                cell.labelField.text = text
                
                switch self.cellConfigList[indexPath.section] {
                case .input(let input, let cellName, _):
                    self.cellConfigList[indexPath.section] = CellCreateGrid.input(input, cellName: cellName, currentValue: text)
                default:
                    return
                }
            }
        
            showInput.start(view: cell)
        
        } else if ((cell as? CellConfigFinish) != nil) {
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
}

extension CreateGridViewController: CollectionStepyByStepLayoutDelegate {
    
    func numberOfInputsAtStep(section: Int) -> Int {
        var count = 0
        var sectionCurrent = section + 1
        while cellConfigList.count != sectionCurrent && Mirror(reflecting: cellConfigList[sectionCurrent]).children.first?.label! != "name" {
            count += 1
            sectionCurrent += 1
        }
        
        return count
    }
    
    func cellTypeAt(section: Int, row: Int) -> CellStepByStepType {
        let currentCell = cellConfigList[section]
        
        if Mirror(reflecting: currentCell).children.first?.label! == "name" && row == 0 {
            return .step
        } else {
            switch currentCell {
            case .name:
                return .name
            case .input:
                return .input
            case .finish:
                return .finish
            }
        }
    }

}
