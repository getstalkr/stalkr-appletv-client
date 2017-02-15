//
//  TrevisCell.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 15/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class CellTrevis: SlotableCellDefault, SlotableCell, SubscriberCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    let slotWidth = 1
    let slotHeight = 3
    
    let webSocketHandles: [String: (_ data: Any?) -> Void] = [
        "my-event": { data in
            // TODO
            
            if let data = data {
                print(data)
            } else {
                print("nothing")
            }
        }
    ]
    
    func load(params: [String: Any]) {
        self.table.delegate = self
        self.table.dataSource = self
        
        self.table.register(CellTrevisTableCell.self, forCellReuseIdentifier: "CellTrevisTableCell")
        self.table.register(UINib(nibName: "CellTrevisTableCell", bundle: nil), forCellReuseIdentifier: "CellTrevisTableCell")
        
        /*
        self.label.text = (params["label"] as! String)
        
        if let paramAlert = params["alert"] as? String {
            self.alertMessage = paramAlert
        }*/
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        /*if let alertMessage = self.alertMessage {
            self.label.text = alertMessage
        } else {
            self.label.text = "sem alerta definido"
        }*/
    }
    
    // table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTrevisTableCell", for: indexPath) as! CellTrevisTableCell
        
        cell.viewLeft.backgroundColor = UIColor.green
        
        cell.labelCheckmark.text = "✓"
        cell.labelCheckmark.textColor = UIColor.green
        
        cell.labelBranch.text = "master"
        cell.labelBranch.textColor = UIColor.green
        cell.labelCommitterName.text = "matt"
        cell.labelCommitMessage.text = "Merge pull request #3 from stalkr/foo"
        
        cell.labelCountPassed.text = "#4 passed"
        cell.labelCountPassed.textColor = UIColor.green
        
        return cell
    }
}
