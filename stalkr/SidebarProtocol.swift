//
//  SidebarProtocol.swift
//  stalkr
//
//  Created by Edvaldo Junior on 24/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation

protocol SidebarProtocol: class {
    
    func focusedCell(withOption option: String)
    
    func selectedCell(withIndex index: IndexPath)
}
