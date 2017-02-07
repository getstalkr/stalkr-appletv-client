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
    
    // todo: o xib da célula precisará ser registrado
}
