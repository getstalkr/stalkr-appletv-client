//
//  CellCommitsFeed.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 17/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import Kingfisher
//import SwiftRichString
import SwiftyJSON
import RelativeFormatter
import PusherSwift
import GridView

class CellCommitsFeed: SlotableCellDefault, SlotableCell, StalkrCell, SubscriberCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    static let cellName = "Commits Feed"
    static let slotWidth = 1
    static let slotHeight = 1
    static let haveZoom = false
    let cellHeight = (UINib(nibName: "CellCommitsFeedTableCell", bundle: nil).instantiate(withOwner: nil, options: nil).last as! UIView).frame.size.height
    
    var commitsLog: [CommitRegister] = []
    
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
                let cell = (cell as! CellCommitsFeed)
                
                cell.commitsLog.insert(CommitRegister(json: json), at: 0)
                cell.table.reloadData()
            }
        )
    ]
    
    //
    func load() {
        self.table.delegate = self
        self.table.dataSource = self
        
        self.table.register(CellCommitsFeedTableCell.self, forCellReuseIdentifier: "CellCommitsFeedTableCell")
        self.table.register(UINib(nibName: "CellCommitsFeedTableCell", bundle: nil), forCellReuseIdentifier: "CellCommitsFeedTableCell")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commitsLog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCommitsFeedTableCell", for: indexPath) as! CellCommitsFeedTableCell
        let currentCommit = commitsLog[indexPath.row]
        
        if let imageUrl = currentCommit.imageUrl {
            cell.imagePhoto.kf.setImage(with: URL(string: imageUrl))
            cell.imagePhoto.asCircle()
        }
        cell.labelCommitterName.text = currentCommit.name
        cell.textMessage.textColor = UIColor.fontPullMessage
        cell.textMessage.text = currentCommit.message
        //cell.labelCommitHash.attributedText = "Commit " + currentCommit.sha.set(style: .fontBold)
        cell.labelCommitHash.text = "Commit " + currentCommit.sha
        //cell.labelBranch.attributedText = "Branch " + "Master".set(style: .fontBold) // TODO
        cell.labelBranch.text = "Branch " + "Master" // TODO
        cell.labelTimeAgo.text = currentCommit.date.relativeFormatted()
        
        return cell
    }

}
