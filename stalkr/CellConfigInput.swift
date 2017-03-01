//
//  CellConfigInput.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 23/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class CellConfigInput: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var labelParamName: UILabel!
    @IBOutlet weak var inputField: UITextField!
    var delegate: CreateGridConfigInputDelegate?
    
    override func awakeFromNib() {
        self.inputField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate!.finishEditFieldText(text: textField.text!)
    }
    
}
