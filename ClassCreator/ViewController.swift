//
//  ViewController.swift
//  ClassCreator
//
//  Created by Scott Mehus on 8/27/19.
//  Copyright © 2019 Scott Mehus. All rights reserved.
//

import UIKit
import CoreData

@objc protocol Mamal {
    var name: String! { get set }
    var species: String! { get set }
}


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
        let allocatedClass: AnyClass = objc_allocateClassPair(Flyweight.classForCoder(), "ManagedFlyweight", 0)!
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
        let flyweight = allocatedClass.alloc() as! Flyweight
        flyweight.firstName = "Scott"
        flyweight.lastName = "Mehus"



        print("firstName: \(flyweight.firstName!) lastName: \(flyweight.lastName!)")

    }
}

class Dog: Mamal {
    var name: String!
    var species: String!
}

extension ViewController {
    private func ivars() {
        var count: UInt32 = 0
        let allocatedClass: AnyClass = objc_allocateClassPair(Flyweight.classForCoder(), "Flyweight", 0)!
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

        class_addProtocol(allocatedClass, Mamal.self)

        objc_registerClassPair(allocatedClass)
        let flyweight = allocatedClass.alloc() as! Flyweight
        flyweight.name = "Ginger"
        flyweight.species = "Poodle"

        guard let name = flyweight.name, let species = flyweight.species else { fatalError() }
        print("name: \(name) species: \(species)")
    }
}


@dynamicMemberLookup class Flyweight: NSObject {

    subscript(dynamicMember member: String) -> String? {
        get {
            return value(forKey: member) as? String
        }

        set {
            setValue(newValue, forKey: member)
        }
    }
}
