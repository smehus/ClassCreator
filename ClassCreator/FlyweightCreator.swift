//
//  FlyweightCreator.swift
//  ClassCreator
//
//  Created by Scott Mehus on 9/2/19.
//  Copyright © 2019 Scott Mehus. All rights reserved.
//

import Foundation

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

            var ivarSize = 0
            var ivarAlignment = 0
            NSGetSizeAndAlignment(encoding, &ivarSize, &ivarAlignment)
            class_addIvar(allocatedClass, name, ivarSize, UInt8(ivarAlignment), encoding)
        }

        // Get all Ivars
        let ivarList = class_copyIvarList(T.self, &ivarCount)
        defer { free(ivarList) }

        for ivar in UnsafeBufferPointer(start: ivarList, count: Int(ivarCount)) {
            guard let namePointer = ivar_getName(ivar) else { continue }
            let name = String(cString: namePointer)

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
            guard let namePointer = ivar_getName(ivar) else { print("🔥 Failed to get ivar name"); continue }
            let name = String(cString: namePointer)
            let inputValue = object_getIvar(object, ivar)

            guard let createdClassIvar = class_getInstanceVariable(allocatedClass, name) else { continue }
            object_setIvar(instance, createdClassIvar, inputValue)
        }


        // Populate properties into ivars
        for property in UnsafeBufferPointer(start: propertyList, count: Int(propertyCount)) {
            let namePointer = property_getName(property)
            let name = String(cString: namePointer)
            guard let castedObject = object as? NSObject else { fatalError() }

            let inputValue = castedObject.value(forKey: name)
            guard let createdClassIvar = class_getInstanceVariable(allocatedClass, name) else { continue }
            object_setIvar(instance, createdClassIvar, inputValue)
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
