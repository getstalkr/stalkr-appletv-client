//
//  DashboardProtocol.swift
//  stalkr
//
//  Created by Edvaldo Junior on 16/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation

enum Mode {
    
    case datailed
    case general
}

protocol DashboardProtocol {
    
    var state: Mode { get set }
    
    func didChangeMode()
}
