//
//  CellConfigInput.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 23/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class CellConfigInput: UITableViewCell {
    
    @IBOutlet weak var labelParamName: UILabel!
    @IBOutlet weak var inputField: UITextField!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
