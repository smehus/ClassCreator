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
        ivars()
        properties()
    }
}

extension ViewController {
    private func properties() {
        let creator: FlyweightCreator<Person> = FlyweightCreator(className: "PersonFlyweight", inspectionType: .property)
        let flyweight = creator.generate()
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
        let creator: FlyweightCreator<Dog> = FlyweightCreator(className: "DogFlyweight", inspectionType: .ivar)
        let flyweight = creator.generate()

        flyweight.name = "Ginger"
        flyweight.species = "Poodle"

        print("name \(flyweight.name!) species: \(flyweight.species!)")
    }
}

struct FlyweightCreator<T: AnyObject> {

    enum ClassInspectionType {
        case ivar
        case property
    }

    private let inspectionType: ClassInspectionType
    private let className: String

    init(className: String, inspectionType: ClassInspectionType) {
        self.className = className
        self.inspectionType = inspectionType
    }

    func generate() -> Flyweight {
        var count: UInt32 = 0
        let allocatedClass: AnyClass = objc_allocateClassPair(Flyweight.classForCoder(), className, 0)!
        let ivars = inspectionType == .ivar ? class_copyIvarList(T.self, &count)! : class_copyPropertyList(T.self, &count)

        for ivar in UnsafeBufferPointer(start: ivars, count: Int(count)) {
            let namePointer = inspectionType == .ivar ? ivar_getName(ivar)! : property_getName(ivar)
            let name = String(cString: namePointer)
            print("name: \(name)")

            let encoding = "@"
            var size = 0
            var alignment = 0
            NSGetSizeAndAlignment(encoding, &size, &alignment)
            class_addIvar(allocatedClass, name, size, UInt8(alignment), encoding)
        }

        free(ivars)

//        class_addProtocol(allocatedClass, Mamal.self)

        objc_registerClassPair(allocatedClass)

        return allocatedClass.alloc() as! Flyweight
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
