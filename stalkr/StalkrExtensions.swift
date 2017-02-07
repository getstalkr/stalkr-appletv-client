//
//  StalkrExtensions.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 07/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation

extension NSObject {
    class func className() -> String {
        return NSStringFromClass(self).components(separatedBy: ["."])[1]
    }
}
