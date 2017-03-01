//
//  CreateGridViewController.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 23/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import SwiftRichString

enum CellCreateGrid {
    case name(String)
    case configInput(ConfigInput)
    
    var get: Any {
        switch self {
        case .name(let name):
            return name
        case .configInput(let configInput):
            return configInput
        }
    }
}

class CreateGridViewController: UITableViewController {

    var cellConfigList: [CellCreateGrid] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listAllSlotableCell.forEach { slotableCellClass in
            let configs = (slotableCellClass as! SlotableCell.Type).configurations
            if configs.count > 0 {
                let cellName = (slotableCellClass as! SlotableCell.Type).cellName
                
                cellConfigList.append(CellCreateGrid.name(cellName))
                configs.forEach { cellConfigList.append(CellCreateGrid.configInput($0)) }
            }
        }
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
        case .configInput(let input):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellConfigInput", for: indexPath) as! CellConfigInput
            if input.obligatory {
                cell.labelParamName.attributedText = input.label + " (obligatory)".set(style: .fontItalic)
            } else {
                cell.labelParamName.text = input.label
            }
            cell.layer.shadowColor = UIColor.red.cgColor
            
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
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let x = tableView.cellForRow(at: indexPath)
        (x as! CellConfigInput).inputField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return (cellConfigList[indexPath.row].get as? ConfigInput) != nil
    }

}
