//
//  CellCommitsFeed.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 17/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftRichString
import SwiftyJSON
import RelativeFormatter
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
    static let configurations: [ConfigInput] = [
        ConfigInput(name: "owner", label: "GitHub's user", inputType: .text, obligatory: true),
        ConfigInput(name: "project", label: "GitHub's repository", inputType: .text, obligatory: true)
    ]

    // subscriber
    let webSockets = [
        WebSocketConfig(
            requestStartUrl: "https://stalkr-api-commits-github.herokuapp.com",
            requestStartParams: { config in
                return ["owner": config["owner"] as! String, "project": config["project"] as! String]
            },
            channel: { config in
                let owner = config["owner"] as! String
                let project = config["project"] as! String
                
                return "commits-github-\(owner)-\(project)"
            },
            event: "status-requested"
        )
    ]
    
    let webSocketHandles: [String: (_ data: JSON, _ cell: SlotableCell) -> Void] = [
        "status-requested": { json, cell in
            (cell as! CellCommitsFeed).commitsLog = json["payload"].arrayValue.map { CommitRegister(json: $0) }
            (cell as! CellCommitsFeed).table.reloadData()
        }
    ]
 
    //
    func load(params: [String: Any]) {
        self.table.delegate = self
        self.table.dataSource = self
 
        self.table.register(CellTrevisTableCell.self, forCellReuseIdentifier: "CellCommitsFeedTableCell")
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
        
        cell.imagePhoto.kf.setImage(with: URL(string: currentCommit.imageUrl))
        cell.imagePhoto.asCircle()
        cell.labelCommitterName.text = currentCommit.name
        cell.textMessage.textColor = UIColor.fontPullMessage
        cell.textMessage.text = currentCommit.message
        cell.labelCommitHash.attributedText = "Commit " + currentCommit.sha.set(style: .fontBold)
        cell.labelBranch.attributedText = "Branch " + "Master".set(style: .fontBold) // TODO
        cell.labelTimeAgo.text = currentCommit.date.relativeFormatted()
        
        return cell
    }

}
