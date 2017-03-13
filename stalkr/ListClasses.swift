//
//  ListClasses.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 12/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import Foundation

struct ClassInfo : CustomStringConvertible, Equatable {
    let classObject: AnyClass
    let classNameFull: String
    let className: String
    
    init?(_ classObject: AnyClass?) {
        guard classObject != nil else { return nil }
        
        self.classObject = classObject!
        
        let cName = class_getName(classObject)!
        self.classNameFull = String(cString: cName)
        self.className = self.classNameFull.components(separatedBy: ".").last!
    }
    
    var superclassInfo: ClassInfo? {
        let superclassObject: AnyClass? = class_getSuperclass(self.classObject)
        return ClassInfo(superclassObject)
    }
    
    var description: String {
        return self.classNameFull
    }
    
    static func ==(lhs: ClassInfo, rhs: ClassInfo) -> Bool {
        return lhs.classNameFull == rhs.classNameFull
    }
}

// List classes that are subclasses
func subclasses(of classMother: AnyClass) -> [ClassInfo] {
    let motherClassInfo = ClassInfo(classMother.self)!
    var subclassesList = [ClassInfo]()
    
    var count = UInt32(0)
    let classList = objc_copyClassList(&count)!

    for i in 0..<Int(count) {
        if let classInfo = ClassInfo(classList[i]),
            let superclassInfo = classInfo.superclassInfo,
            superclassInfo == motherClassInfo
        {
            subclassesList.append(classInfo)
        }
    }

    return subclassesList
}

// List classes that subscribers a protocol
func subscribersOfSlotableCell() -> [ClassInfo] { // TODO: Pass a protocol as parameter, without using @objc
    var subscribersList = [ClassInfo]()

    var count = UInt32(0)
    let classList = objc_copyClassList(&count)!
    
    for i in 0..<Int(count) {
        if let classInfo = ClassInfo(classList[i]) {
            
            if let _ = classInfo.classObject as? SlotableCell.Type {
                subscribersList.append(classInfo)
            }
        }
    }
    
    return subscribersList
}
