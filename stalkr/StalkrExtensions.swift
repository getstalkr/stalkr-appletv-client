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

// UIColor
extension UIColor {
    static let backgroundCell = UIColor.init(red: 13/255, green: 14/255, blue: 40/255, alpha: 1.0)
    static let backgroundAbove = UIColor.init(red: 05/255, green: 05/255, blue: 31/255, alpha: 1.0)
    static let fontCellTitle = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    
    static let stalkrError = UIColor.init(red: 219/255, green: 69/255, blue: 69/255, alpha: 1.0)
    static let stalkrSuccess = UIColor.init(red: 57/255, green: 170/255, blue: 86/255, alpha: 1.0)
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
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
extension UIView{
    
    func asCircle() {
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

//
extension UISegmentedControl {
    func replaceSegments(segments: [String]) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
    
    func getSelectedText() -> String {
        return self.titleForSegment(at: self.selectedSegmentIndex)!
    }
}

//
extension UIView {
    func addDashedBorder() {
        let color = UIColor.white.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [1, 1]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 1).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}

//
class ShowInput: UITextField, UITextFieldDelegate {
    
    var callback: ((String) -> Void)?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start(view: UIView) {
        view.addSubview(self)
        super.becomeFirstResponder()
    }


    func textFieldDidEndEditing(_ textField: UITextField) {
        callback?(textField.text!)
        textField.text = ""
        
        textField.removeFromSuperview()
    }
}

// Substring
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: CountableClosedRange<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

// http://stackoverflow.com/a/27184261/3440266
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
