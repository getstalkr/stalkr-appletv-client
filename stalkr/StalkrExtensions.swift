//
//  StalkrExtensions.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 07/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation
import UIKit
import SwiftRichString

extension NSObject {
    class func className() -> String {
        return NSStringFromClass(self).components(separatedBy: ["."])[1]
    }
}

extension UIColor {
    static let backgroundCell = UIColor.init(red: 13/255, green: 14/255, blue: 40/255, alpha: 1.0)
    static let backgroundAbove = UIColor.init(red: 05/255, green: 05/255, blue: 31/255, alpha: 1.0)
    static let fontCellTitle = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    
    static let stalkrError = UIColor.init(red: 219/255, green: 69/255, blue: 69/255, alpha: 1.0)
    static let stalkrSuccess = UIColor.init(red: 57/255, green: 170/255, blue: 86/255, alpha: 1.0)
}

// Date
// http://stackoverflow.com/questions/24777496/how-can-i-convert-string-date-to-nsdate
extension DateFormatter {
    
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {
    
    func toDate (format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
    
    func toDateString (inputFormat: String, outputFormat:String) -> String? {
        if let date = toDate(format: inputFormat) {
            return DateFormatter(format: outputFormat).string(from: date)
        }
        return nil
    }
}

extension Date {
    
    func toString (format:String) -> String? {
        return DateFormatter(format: format).string(from: self)
    }
}

// http://stackoverflow.com/questions/4414221/uiimage-in-a-circle
extension UIImageView{
    
    func asCircle(){
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
    }
    
}

//
extension Style {
    static let fontBold = Style("bold", {
        $0.font = FontAttribute(FontName.HelveticaNeue_Bold, size: 17)
    })
    
    static let fontItalic = Style("italic", {
        $0.font = FontAttribute(FontName.HelveticaNeue_Italic, size: 17)
    })
}
