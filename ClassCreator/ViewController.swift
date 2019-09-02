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

        let context = CoreDataManager.shared.managedContext
        let person = Person(context: context)
        person.firstName = "Ralph"
        person.lastName = "Wiggums"

        CoreDataManager.shared.saveContext()

//        ivars()
        properties()
    }
}

extension ViewController {
    private func properties() {

        let request: NSFetchRequest<Person> = Person.fetchRequest()

        guard let person = try? CoreDataManager.shared.managedContext.fetch(request).first else { fatalError() }

        let creator: FlyweightCreator<Person> = FlyweightCreator(className: "PersonFlyweight")
        let flyweight = creator.generate(from: person)

//        print("firstName: \(flyweight.firstName!) lastName: \(flyweight.lastName!)")

    }
}

@objc class Dog: NSObject {
    var name: NSString!
    var species: NSString!
}

extension ViewController {
    private func ivars() {

        let dog = Dog()
        dog.species = "Poodle"
        dog.name = "Scott"

        let creator: FlyweightCreator<Dog> = FlyweightCreator(className: "DogFlyweight")
        let flyweight = creator.generate(from: dog)

//        print("name: \(flyweight.name!) species: \(flyweight.species!)")
    }
}

struct FlyweightCreator<T: AnyObject> {

    private let className: String

    init(className: String) {
        self.className = className
    }

    func generate(from object: AnyObject) -> Flyweight {
        var propertyCount: UInt32 = 0
        var ivarCount: UInt32 = 0
        let encoding = "@"

        // Create class
        let allocatedClass: AnyClass = objc_allocateClassPair(Flyweight.classForCoder(), className, 0)!


        // Get all properties
        let propertyList = class_copyPropertyList(T.self, &propertyCount)
        defer { free(propertyList) }

        for property in UnsafeBufferPointer(start: propertyList, count: Int(propertyCount)) {
            let namePointer = property_getName(property)
            let name = String(cString: namePointer)
            print("*** Property Name \(name)")


            var ivarSize = 0
            var ivarAlignment = 0
            NSGetSizeAndAlignment(encoding, &ivarSize, &ivarAlignment)
            class_addIvar(allocatedClass, name, ivarSize, UInt8(ivarAlignment), encoding)
        }

        let ivarList = class_copyIvarList(T.self, &ivarCount)
        defer { free(ivarList) }

        for ivar in UnsafeBufferPointer(start: ivarList, count: Int(ivarCount)) {
            guard let namePointer = ivar_getName(ivar) else { continue }
            let name = String(cString: namePointer)
            print("*** Ivar Name \(name)")

            var ivarSize = 0
            var ivarAlignment = 0
            NSGetSizeAndAlignment(encoding, &ivarSize, &ivarAlignment)
            class_addIvar(allocatedClass, name, ivarSize, UInt8(ivarAlignment), encoding)
        }

//        class_addProtocol(allocatedClass, Mamal.self)

        // Register class
        objc_registerClassPair(allocatedClass)


        // Creat instance of new class
        let instance = allocatedClass.alloc() as! Flyweight


        // Populate new class ivars with input instance
        for ivar in UnsafeBufferPointer(start: ivarList, count: Int(ivarCount)) {
            let namePointer = property_getName(ivar)
            let name = String(cString: namePointer)

            // Get Dog Speciies value
            let objectIvar = class_getProperty(T.self, name)!
            let objectValue = property_getAttributes(objectIvar)

            // Set Dog Speciies Value on the flyweight

            let flyweightIvar = class_getInstanceVariable(allocatedClass, name)!
            object_setIvar(instance, flyweightIvar, objectValue)
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
