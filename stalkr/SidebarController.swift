//
//  ProjectsTableViewController.swift
//  stalkr
//
//  Created by Edvaldo Junior on 15/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SidebarController: UITableViewController {
    
    var shouldSelectEspecificTab = false
    var currentSelected = IndexPath(row: 0, section: 0)
    var sidebarProtocol: SidebarProtocol?

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SidebarOptions.allValues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CellSidebarMenu
        
        cell.sidebarProtocol = sidebarProtocol
        cell.myOption = SidebarOptions.allValues[indexPath.row]
        
        return cell
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        if let cell = context.nextFocusedItem as? CellSidebarMenu {
            currentSelected = tableView.indexPath(for: cell)!
            shouldSelectEspecificTab = false
            
            sidebarProtocol?.toggle(showSidebar: true)
        } else {
            shouldSelectEspecificTab = true
            
            sidebarProtocol?.toggle(showSidebar: false)
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if shouldSelectEspecificTab && currentSelected.row != indexPath.row {
            return false
        }
        
        return true
    }
}
