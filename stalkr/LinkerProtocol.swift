//
//  LinkerProtocol.swift
//  stalkr
//
//  Created by Edvaldo Junior on 05/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import UIKit

protocol LinkerProtocol: class {
    
    func linkToSidebar(fromView: UIView, toItem: IndexPath, inView: UIView)
}
