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
        ivars()
        properties()
    }
}

extension ViewController {
    private func properties() {
//        let creator: FlyweightCreator<Person> = FlyweightCreator(className: "PersonFlyweight", inspectionType: .property)
//        let flyweight = creator.generate()
//        flyweight.firstName = "Scott"
//        flyweight.lastName = "Mehus"
//
//        print("firstName: \(flyweight.firstName!) lastName: \(flyweight.lastName!)")

    }
}

@objc class Dog: NSObject {
    var species: String!
}

extension ViewController {
    private func ivars() {

        let dog = Dog()
        dog.species = "Scott"
//
//        Bridge.getIvar(dog)



        let creator: FlyweightCreator<Dog> = FlyweightCreator(className: "DogFlyweight", inspectionType: .ivar)
        let flyweight = creator.generate(from: dog)

        print("species: \(flyweight.species!)")
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

    func generate(from object: AnyObject) -> Flyweight {
        var count: UInt32 = 0
        // Create class
        let allocatedClass: AnyClass = objc_allocateClassPair(Flyweight.classForCoder(), className, 0)!

        // Get all ivars out of input class
        let ivars = inspectionType == .ivar ? class_copyIvarList(T.self, &count)! : class_copyPropertyList(T.self, &count)
        defer { free(ivars) }


        // Copy over ivars from input class into created class
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



//        class_addProtocol(allocatedClass, Mamal.self)

        // Register class
        objc_registerClassPair(allocatedClass)

        // Creat instance of new class
        let instance = allocatedClass.alloc() as! Flyweight

        // Populate new class ivars with input instance
        for ivar in UnsafeBufferPointer(start: ivars, count: Int(count)) {
            let namePointer = inspectionType == .ivar ? ivar_getName(ivar)! : property_getName(ivar)
            let name = String(cString: namePointer)

            // Get Dog Speciies value

            let i = class_getInstanceVariable(Dog.self, "species")!
            let iVal = object_getIvar(object, i)

            // This seems to work.....
            let objectIvar = class_getInstanceVariable(allocatedClass, "species")
            let value = object_getIvar(instance, objectIvar!)


            // Set Dog Speciies Value on the flyweight
//            let flyweightIvar: Ivar! = inspectionType == .ivar ? class_getInstanceVariable(allocatedClass, name)! : class_getProperty(Dog.self, name)
//            object_setIvar(instance, flyweightIvar, value)

            print("alksdjfk")
            print("alksdjfk")
            print("alksdjfk")
        }

        return instance
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
