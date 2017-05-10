//
//  SidebarProtocol.swift
//  stalkr
//
//  Created by Edvaldo Junior on 24/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation

enum SidebarOptions: String, CustomStringConvertible {
    case dashboard = "Dashboard"
    case newDasboard = "New Dasboard"
    case myAccount = "My Account"
    
    static let allValues = [dashboard, newDasboard, myAccount]
    
    var description: String {
        return self.rawValue.uppercased()
    }
}

protocol SidebarProtocol: class {
    
    func focusedCell(withOption option: SidebarOptions)
}
