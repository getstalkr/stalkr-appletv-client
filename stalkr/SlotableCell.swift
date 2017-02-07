//
//  CellSlotable.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 06/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation

protocol SlotableCell {
    var slotWidth: Int { get }
    var slotHeight: Int { get }
    
    func load(params: [String: Any])
}

// lista com todos as classes que implementam o protocolo SlotableCell
// todo: talvez haja alguma forma mística de gerar essa listagem automaticamente
let listAllSlotableCell: [NSObject.Type] = [
    CellPlaceholderSmall.self,
    CellPlaceholderWidthTwo.self,
    CellPlaceholderHeightTwo.self,
    CellPlaceholderTwoXTwo.self
]
