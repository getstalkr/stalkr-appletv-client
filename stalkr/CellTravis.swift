//
//  TravisCell.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 15/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import SwiftRichString
import RelativeFormatter
import PusherSwift
import GridView

class CellTravis: SlotableCellDefault, SlotableCell, StalkrCell, SubscriberCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    static let cellName = "Travis"
    static let slotWidth = 1
    static let slotHeight = 2
    static let haveZoom = false
    let cellHeight = (UINib(nibName: "CellTravisTableCell", bundle: nil).instantiate(withOwner: nil, options: nil).last as! UIView).frame.size.height
    
    var travisBuildsLog: [(buildNumber: String, register: TravisBuildRegister)] = []
    
    // config
    static let configurations: [StalkrCellConfig] = [
        StalkrCellConfig(name: "pusher_key", label: "Pusher key", obligatory: true),
        StalkrCellConfig(name: "stalkr_project", label: "Stalkr Project", obligatory: true),
        StalkrCellConfig(name: "stalkr_team", label: "Stalkr Team", obligatory: true)
    ]
    
    // subscriber
    var pusher: Pusher?
    
    let webSockets = [
        WebSocketConfig(
            channel: { config in
                let stalkrProject = config["stalkr_project"] as! String
                let stalkrTeam = config["stalkr_team"] as! String
                
                return "\(stalkrProject)@\(stalkrTeam)"
            },
            event: "push",
            
            handle: { json, cell in
                let cell = cell as! CellTravis
                
                let travisRegister = TravisBuildRegister(json: json)
                
                // check if it's a new build, or a change of a previus buils
                let indexOfPrevius = cell.travisBuildsLog.index(where: { number, _ in
                    return number == travisRegister.number })
                
                if let indexOfPrevius = indexOfPrevius {
                    cell.travisBuildsLog[indexOfPrevius] = (buildNumber: travisRegister.number, register: travisRegister)
                } else {
                    cell.travisBuildsLog.insert(
                        (buildNumber: travisRegister.number, register: travisRegister),
                        at: 0
                    )
                }
                
                //
                cell.table.reloadData()
            }
        )
    ]
    
    //
    func load(params: [String: Any]) {
        self.table.delegate = self
        self.table.dataSource = self
        
        self.table.register(CellTravisTableCell.self, forCellReuseIdentifier: "CellTravisTableCell")
        self.table.register(UINib(nibName: "CellTravisTableCell", bundle: nil), forCellReuseIdentifier: "CellTravisTableCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTravisTableCell", for: indexPath) as! CellTravisTableCell
        let (_, currentBuild) = travisBuildsLog[indexPath.row]
        
        switch currentBuild.state {
        case .running:
            cell.viewLeft.backgroundColor = UIColor.yellow
            cell.labelCheckmark.text = "."
            cell.labelCheckmark.textColor = UIColor.yellow
        case .success:
            cell.viewLeft.backgroundColor = UIColor.stalkrSuccess
            cell.labelCheckmark.text = "✓"
            cell.labelCheckmark.textColor = UIColor.stalkrSuccess
        case .failed:
            cell.viewLeft.backgroundColor = UIColor.stalkrError
            cell.labelCheckmark.text = "x"
            cell.labelCheckmark.textColor = UIColor.stalkrError
        }
        
        cell.labelCommitMessage.text = "\(currentBuild.eventType) #\(currentBuild.number)"
        cell.textCommitMessage.text = currentBuild.message
        cell.textCommitMessage.textColor = UIColor.fontPullMessage
        
        cell.labelBranch.attributedText = "Branch " + currentBuild.branch.set(style: .fontBold)
        cell.labelCommitterName.text = currentBuild.authorName
        cell.labelCommitCode.attributedText = "Commit " + currentBuild.commit.set(style: .fontBold)
        
        if let dateStarted = currentBuild.dateStarted {
            
            let dateFinishRelativeFormatted = dateStarted.relativeFormatted()
            let splited = dateFinishRelativeFormatted.components(separatedBy: " ")
            
            if splited.count == 3 && splited[2] == "ago" {
                cell.labelPastTime.attributedText = "\(splited[0]) \(splited[1])".set(style: .fontBold) + " \(splited[2])"
            } else {
                cell.labelPastTime.attributedText = dateFinishRelativeFormatted.set(style: .fontBold)
            }
            
            if let dateFinish = currentBuild.dateFinish {
                
                let dateComponentsFormatter = DateComponentsFormatter()
                dateComponentsFormatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
                dateComponentsFormatter.maximumUnitCount = 2
                dateComponentsFormatter.unitsStyle = .abbreviated
                
                let totalTime = dateComponentsFormatter.string(from: dateStarted, to: dateFinish)
                
                if let totalTime = totalTime {
                    cell.labelTotalTime.attributedText = "Total time: " + totalTime.set(style: .fontBold)
                } else {
                    cell.labelTotalTime.text = ""
                }
            } else {
                cell.labelTotalTime.text = ""
            }
        
        } else {
            // todo & warning: for some reason, if we set a blank text for this labels, the autolayout crash
            cell.labelPastTime.text = " "
            cell.labelTotalTime.text = " "
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
