//
//  CreateGridViewController.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 23/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import SwiftRichString

protocol CreateGridConfigInputDelegate {
    func finishEditFieldText(text: String)
}

protocol CreateGridButtonCreateProjectDelegate {
    func buttonCreateProjectClicked()
}

enum CellCreateGrid {
    case name(String)
    case configInput(ConfigInput, cellName: String, textFieldValue: String)
    case buttonCreateProject()
}

class CreateGridViewController: UITableViewController, CreateGridConfigInputDelegate, CreateGridButtonCreateProjectDelegate {

    var cellConfigList: [CellCreateGrid] = []
    var lastCellConfigSelected = IndexPath(row: 1, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellConfigList.append(CellCreateGrid.name("Project"))
        cellConfigList.append(CellCreateGrid.configInput(ConfigInput(name: "projectName", label: "Project name", inputType: .text, obligatory: true), cellName: "project", textFieldValue: ""))

        listAllSlotableCell.forEach { slotableCellClass in
            let configs = (slotableCellClass as! SlotableCell.Type).configurations
            if configs.count > 0 {
                let cellName = (slotableCellClass as! SlotableCell.Type).cellName
                
                cellConfigList.append(CellCreateGrid.name(cellName))
                configs.forEach { cellConfigList.append(CellCreateGrid.configInput($0, cellName: slotableCellClass.className(), textFieldValue: "")) }
            }
        }
        
        cellConfigList.append(CellCreateGrid.buttonCreateProject())
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellConfigList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = cellConfigList[indexPath.row]
        
        switch currentCell {
        case .name(let name):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellConfigTitle", for: indexPath) as! CellConfigTitle
            cell.labelTitle.text = name
            
            return cell
        case .configInput(let input, _, let value):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellConfigInput", for: indexPath) as! CellConfigInput
            if input.obligatory {
                cell.labelParamName.attributedText = input.label + " (obligatory)".set(style: .fontItalic)
            } else {
                cell.labelParamName.text = input.label
            }
            cell.delegate = self
            cell.inputField.text = value
            cell.layer.shadowColor = UIColor.black.cgColor
            
            return cell
        case .buttonCreateProject():
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellConfigCreateButton", for: indexPath) as! CellConfigCreateButton
            cell.delegate = self
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if ((context.previouslyFocusedIndexPath) != nil) {
            let cell = tableView.cellForRow(at: context.previouslyFocusedIndexPath!)
            cell?.layer.shadowOpacity = 0.0
        }
        
        if ((context.nextFocusedIndexPath) != nil) {
            let cell = tableView.cellForRow(at: context.nextFocusedIndexPath!)
            cell?.layer.shadowOpacity = 1.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentCell = cellConfigList[indexPath.row]
        
        switch currentCell {
        case .name(_):
            return 60
        case .configInput(_):
            return 130
        case .buttonCreateProject():
            return 130
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch cellConfigList[indexPath.row] {
        case .configInput(_):
            lastCellConfigSelected = indexPath
            let cell = tableView.cellForRow(at: indexPath) as! CellConfigInput
            cell.inputField.becomeFirstResponder()
            
        case .buttonCreateProject():
            let cell = tableView.cellForRow(at: indexPath) as! CellConfigCreateButton
            cell.btnCreateProject(cell)
            
        default:
            return
        }
    }
    
    func finishEditFieldText(text: String) {
        switch cellConfigList[lastCellConfigSelected.row] {
        case .configInput(let input, let cellName, _):
            cellConfigList[lastCellConfigSelected.row] = CellCreateGrid.configInput(input, cellName: cellName, textFieldValue: text)
        default:
            return
        }
    }
    
    func buttonCreateProjectClicked() {
        var configGridName: String = ""
        var configCellPlaceholderSmall: [String:String] = [:]
        var configlCellCloudPerformance: [String:String] = [:]
        var configlCellTrevis: [String:String] = [:]
        var configlCellTeamCommits: [String:String] = [:]
        var configlCellDeployStatus: [String:String] = [:]
        var configlCellCommitsFeed: [String:String] = [:]
        
        
        var pos = -1
        for i in cellConfigList {
            pos += 1
            
            //
            if case .configInput = i { } else { continue }
            
            //
            if case let .configInput(config, cellName, value) = i {
                if config.obligatory && value == "" {
                    self.tableView.selectRow(at: IndexPath(row: pos, section: 0), animated: true, scrollPosition: .middle)
                    // todo: precisa mudar o focus para a célula selecionada
                    // todo: precisa destacar o nome "obrigatório" nas células
                    return
                }
            
                //
                switch cellName {
                case "project":
                    configGridName = value
                case "CellPlaceholderSmall":
                    configCellPlaceholderSmall[config.name] = value
                case "CellTrevis":
                    configlCellTrevis[config.name] = value
                default:
                    break
                }
            }
        }
        
        let json = "" +
            "[" +
                "[" +
                    "{ \"cell\": \"CellCloudPerformance\", \"params\": { } }," +
                    "{ \"cell\": \"CellTrevis\", \"params\": { }, \"websocket\": { \"channel\": \"travis-builds-\(configlCellTrevis["trevisUser"]!)-\(configlCellTrevis["trevisRepository"]!)\", \"event\": \"status-requested\" } }," +
                    "{ \"cell\": \"CellTeamCommits\", \"params\": { } }" +
                "]," +
                "[" +
                    "{ \"cell\": \"CellDeployStatus\", \"params\": { } }," +
                    "{ \"cell\": \"CellCommitsFeed\", \"params\": { } }" +
                "]" +
            "]"
        
        print(configGridName)
        print(json)
    }
    
    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        switch cellConfigList[indexPath.row] {
        case .name(_):
            return false
        case .configInput(_):
            return true
        case .buttonCreateProject():
            return true
        }
    }
}
