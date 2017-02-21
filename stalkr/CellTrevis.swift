//
//  TrevisCell.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 15/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import SwiftRichString
import SwiftyJSON
import RelativeFormatter

class CellTrevis: SlotableCellDefault, SlotableCell, SubscriberCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    let slotWidth = 1
    let slotHeight = 2
    let cellHeight = (UINib(nibName: "CellTrevisTableCell", bundle: nil).instantiate(withOwner: nil, options: nil).last as! UIView).frame.size.height
    
    var travisBuildsLog: [TravisBuildRegister] = []
    
    let webSocketHandles: [String: (_ data: JSON, _ cell: SlotableCell) -> Void] = [
        "status-requested": { json, cell in
            (cell as! CellTrevis).travisBuildsLog = json["currentData"].arrayValue.map { TravisBuildRegister(json: $0) }
            (cell as! CellTrevis).table.reloadData()
        }
    ]
    
    func load(params: [String: Any]) {
        self.table.delegate = self
        self.table.dataSource = self
        
        self.table.register(CellTrevisTableCell.self, forCellReuseIdentifier: "CellTrevisTableCell")
        self.table.register(UINib(nibName: "CellTrevisTableCell", bundle: nil), forCellReuseIdentifier: "CellTrevisTableCell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travisBuildsLog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTrevisTableCell", for: indexPath) as! CellTrevisTableCell
        let currentBuild = travisBuildsLog[indexPath.row]
        
        cell.viewLeft.backgroundColor = UIColor.stalkrSuccess // TODO
        
        cell.labelCheckmark.text = "✓" // TODO
        cell.labelCheckmark.textColor = UIColor.stalkrSuccess
        cell.labelCommitMessage.text = "\(currentBuild.eventType) #\(currentBuild.number)"
        cell.textCommitMessage.text = currentBuild.message
        cell.textCommitMessage.textColor = UIColor.fontPullMessage
        
        cell.labelBranch.attributedText = "Branch " + currentBuild.branch.set(style: .fontBold)
        cell.labelCommitterName.text = "matt" // TODO
        cell.labelCommitCode.attributedText = "Commit " + currentBuild.commit.set(style: .fontBold)
        
        if let dateFinish = currentBuild.dateFinish {
            let dateFinishRelativeFormatted = dateFinish.relativeFormatted()
            let splited = dateFinishRelativeFormatted.components(separatedBy: " ")
            
            if splited.count == 3 && splited[2] == "ago" {
                cell.labelPastTime.attributedText = "\(splited[0]) \(splited[1])".set(style: .fontBold) + " \(splited[2])"
            } else {
                cell.labelPastTime.attributedText = dateFinishRelativeFormatted.set(style: .fontBold)
            }
            
            cell.labelRunTime.attributedText = "Ran for " + "\(currentBuild.duration / 60) min \(currentBuild.duration % 60) sec".set(style: .fontBold)
            cell.labelTotalTime.attributedText = "Total time: " + "6 min".set(style: .fontBold) // TODO
        } else {
            cell.labelPastTime.text = ""
            cell.labelRunTime.text = ""
            cell.labelTotalTime.text = ""
        }
        
        return cell
    }
}

extension UIColor {
    static let fontPullRequest = UIColor.init(red: 55/255, green: 57/255, blue: 76/255, alpha: 1.0)
    static let fontPullTitle = UIColor.init(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0)
    static let fontPullMessage = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
    static let fontDetails = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
}
