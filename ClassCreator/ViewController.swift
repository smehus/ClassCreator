//
//  ViewController.swift
//  ClassCreator
//
//  Created by Scott Mehus on 8/27/19.
//  Copyright © 2019 Scott Mehus. All rights reserved.
//

import UIKit
import CoreData



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        ivars()
        properties()
    }
}

extension ViewController {
    private func properties() {
        var count: UInt32 = 0
        let allocatedClass: AnyClass = objc_allocateClassPair(NSObject.classForCoder(), "ManagedFlyweight", 0)!
        let props = class_copyPropertyList(Person.self, &count)!

        for prop in UnsafeBufferPointer(start: props, count: Int(count)) {
            let namePointer = property_getName(prop)
            let name = String(cString: namePointer)
            print("name: \(name)")

            let encoding = "@"
            var size = 0
            var alignment = 0
            NSGetSizeAndAlignment(encoding, &size, &alignment)
            class_addIvar(allocatedClass, name, size, UInt8(alignment), encoding)
        }

        free(props)

        objc_registerClassPair(allocatedClass)
        let flyweight = allocatedClass.alloc() as! NSObject
        flyweight.setValue("Scott", forKey: "firstName")
        flyweight.setValue("Mehus", forKey: "lastName")

        print("firstName: \(flyweight.value(forKey: "firstName")!) lastName: \(flyweight.value(forKey: "lastName")!)")

    }
}

class Dog {
    var name: String!
    var breed: String!
}

extension ViewController {
    private func ivars() {
        var count: UInt32 = 0
        let allocatedClass: AnyClass = objc_allocateClassPair(NSObject.classForCoder(), "Flyweight", 0)!
        let ivars = class_copyIvarList(Dog.self, &count)!


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

        free(ivars)

        objc_registerClassPair(allocatedClass)
        let flyweight = allocatedClass.alloc() as! NSObject
        flyweight.setValue("Ginger", forKey: "name")
        flyweight.setValue("Poodle", forKey: "breed")

        print("name: \(flyweight.value(forKey: "name")!) breed: \(flyweight.value(forKey: "breed")!)")
    }
}

