//
//  ViewController.swift
//  ClassCreator
//
//  Created by Scott Mehus on 8/27/19.
//  Copyright © 2019 Scott Mehus. All rights reserved.
//

import UIKit
import CoreData
import ObjectiveC.runtime

@objc class Person: NSManagedObject {
    @NSManaged var firstName: String!
    @NSManaged var lastName: String!
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var count: UInt32 = 0
        let allocatedClass: AnyClass = objc_allocateClassPair(NSObject.classForCoder(), "Flyweight", 0)!
        let ivars = class_copyIvarList(Person.self, &count)!
        

        for ivar in UnsafeBufferPointer(start: ivars, count: Int(count)) {
            let namePointer = ivar_getName(ivar)!
            let name = String(cString: namePointer)
            print("name: \(name)")

            let encoding = "@"
            var size = 0
            var alignment = 0
            NSGetSizeAndAlignment(encoding, &size, &alignment)
            class_addIvar(allocatedClass, name, size, UInt8(alignment), encoding)
        }

        objc_registerClassPair(allocatedClass)
        let flyweight = allocatedClass.alloc() as! NSObject
        flyweight.setValue("Scott", forKey: "firstName")
        flyweight.setValue("Mehus", forKey: "lastName")

        print("firstName: \(flyweight.value(forKey: "firstName")) lastName: \(flyweight.value(forKey: "lastName"))")
    }
}

