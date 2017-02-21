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

class CellCommitsFeed: SlotableCellDefault, SlotableCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    let slotWidth = 1
    let slotHeight = 1
    let cellHeight = (UINib(nibName: "CellCommitsFeedTableCell", bundle: nil).instantiate(withOwner: nil, options: nil).last as! UIView).frame.size.height
    
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCommitsFeedTableCell", for: indexPath) as! CellCommitsFeedTableCell
        
        cell.imagePhoto.kf.setImage(with: URL(string: "https://avatars0.githubusercontent.com/u/9501115"))
        cell.imagePhoto.asCircle()
        cell.textMessage.textColor = UIColor.fontPullMessage
        cell.labelCommitHash.attributedText = "Commit " + "be5e5440".set(style: .fontBold)
        cell.labelBranch.attributedText = "Branch " + "Master".set(style: .fontBold)
        
        return cell
    }

}
