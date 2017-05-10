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
}
