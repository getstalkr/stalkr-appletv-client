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

    let optionsNames: [String] = ["DASHBOARD", "NEW DASHBOARD", "MY ACCOUNT"]
    
    var sidebarProtocol: SidebarProtocol?

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CellSidebarMenu
        
        cell.sidebarProtocol = sidebarProtocol
        cell.textLabel!.text = optionsNames[indexPath.row]
        
        return cell
    }
}
