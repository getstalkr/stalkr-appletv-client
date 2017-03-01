//
//  SlotableCellConfiguration.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 23/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation

enum InputType {
    case text
    case number
}

struct ConfigInput {
    let name: String
    let label: String
    let inputType: InputType
    let obligatory: Bool
}
