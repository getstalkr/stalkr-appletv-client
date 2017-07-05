//
//  SidebarProtocol.swift
//  stalkr
//
//  Created by Edvaldo Junior on 24/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

enum SidebarOptions: String, CustomStringConvertible {
    case dashboard = "Dashboard"
    case myAccount = "My Account"
    
    static let allValues = [dashboard, myAccount]
    
    var description: String {
        return self.rawValue.uppercased()
    }
    
    var instantiateController: UIViewController? {
        switch self {
        case .dashboard:
            return UIStoryboard(name: "ProjectsView", bundle: nil).instantiateInitialViewController()
            
        case .myAccount:
            return UIStoryboard(name: "Account", bundle: nil).instantiateInitialViewController()
        }
    }
}

protocol SidebarProtocol: class {
    
    func toggle(showSidebar: Bool)
    func focusedCell(withOption option: SidebarOptions)
}
