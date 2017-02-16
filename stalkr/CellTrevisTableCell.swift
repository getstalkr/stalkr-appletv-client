//
//  CellTrevisTableCell.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 15/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class CellTrevisTableCell: UITableViewCell {

    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var labelCheckmark: UILabel!
    @IBOutlet weak var labelCommitMessage: UILabel!
    @IBOutlet weak var textCommitMessage: UITextView!
    @IBOutlet weak var labelCommitterName: UILabel!
    @IBOutlet weak var labelCommitCode: UILabel!
    @IBOutlet weak var labelBranch: UILabel!
    @IBOutlet weak var labelPastTime: UILabel!
    @IBOutlet weak var labelRunTime: UILabel!
    @IBOutlet weak var labelTotalTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
