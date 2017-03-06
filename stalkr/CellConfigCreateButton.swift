//
//  CellConfigCreateButton.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 28/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class CellConfigCreateButton: UITableViewCell {
    
    var delegate: CreateGridButtonCreateProjectDelegate?

    @IBAction func btnCreateProject(_ sender: Any) {
        delegate!.buttonCreateProjectClicked()
    }
}
