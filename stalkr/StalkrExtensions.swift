//
//  StalkrExtensions.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 07/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    class func className() -> String {
        return NSStringFromClass(self).components(separatedBy: ["."])[1]
    }
}

extension UIColor {
    static let backgroundCell = UIColor.init(red: 13/255, green: 14/255, blue: 40/255, alpha: 1.0)
    static let backgroundAbove = UIColor.init(red: 05/255, green: 05/255, blue: 31/255, alpha: 1.0)
    static let fontCellTitle = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
}
