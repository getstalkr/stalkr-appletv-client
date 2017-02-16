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

class CellTrevis: SlotableCellDefault, SlotableCell, SubscriberCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    let slotWidth = 1
    let slotHeight = 3
    let cellHeight = (UINib(nibName: "CellTrevisTableCell", bundle: nil).instantiate(withOwner: nil, options: nil).last as! UIView).frame.size.height
    
    let webSocketHandles: [String: (_ data: Any?) -> Void] = [
        "status-requested": { object in
            // TODO
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTrevisTableCell", for: indexPath) as! CellTrevisTableCell
        
        cell.viewLeft.backgroundColor = UIColor.stalkrSuccess
        
        cell.labelCheckmark.text = "✓"
        cell.labelCheckmark.textColor = UIColor.stalkrSuccess
        cell.labelCommitMessage.text = "Pull request #3"
        cell.textCommitMessage.textColor = UIColor.fontPullMessage
        
        let styleBold = Style("bold", {
            $0.font = FontAttribute(FontName.HelveticaNeue_Bold, size: 17)
        })
        cell.labelBranch.attributedText = "Branch " + "Master".set(style: styleBold)
        cell.labelCommitterName.text = "matt"
        cell.labelCommitCode.attributedText = "Commit " + "b5e5061".set(style: styleBold)
        
        cell.labelPastTime.attributedText = "3 months".set(style: styleBold) + " ago"
        cell.labelRunTime.attributedText = "Ran for " + "0 min 42 sec".set(style: styleBold)
        cell.labelTotalTime.attributedText = "Total time: " + "6 min".set(style: styleBold)
        
        return cell
    }
}

extension UIColor {
    static let fontPullRequest = UIColor.init(red: 55/255, green: 57/255, blue: 76/255, alpha: 1.0)
    static let fontPullTitle = UIColor.init(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0)
    static let fontPullMessage = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
    static let fontDetails = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let stalkrError = UIColor.init(red: 219/255, green: 69/255, blue: 69/255, alpha: 1.0)
    static let stalkrSuccess = UIColor.init(red: 57/255, green: 170/255, blue: 86/255, alpha: 1.0)
}
