//
//  ClassCreatorTests.swift
//  ClassCreatorTests
//
//  Created by Scott Mehus on 9/2/19.
//  Copyright © 2019 Scott Mehus. All rights reserved.
//

import XCTest
@testable import ClassCreator
import CoreData

class ClassCreatorTests: XCTestCase {

    override func setUp() {
        let context = CoreDataManager.shared.managedContext
        let person = Person(context: context)
        person.firstName = "Ralph"
        person.lastName = "Wiggums"

        CoreDataManager.shared.saveContext()

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_swizzle() {
        let originalSelector = #selector(UIViewController.viewWillAppear(_:))
        let replacementSelector = #selector(myViewWillAppear(animated:))

        let originalMethod = class_getInstanceMethod(ViewController.self, originalSelector)
        let replacementMethod = class_getInstanceMethod(type(of: self), replacementSelector)

        let didAddMethod = class_addMethod(ViewController.self, replacementSelector, method_getImplementation(replacementMethod!), method_getTypeEncoding(replacementMethod!))
        if didAddMethod {
            class_replaceMethod(ViewController.self, replacementSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, replacementMethod!);
        }
    }

    func myViewWillAppear(animated: Bool) {
        print("*** hYEYEYEYEYEYOO IT WORKS")
    }

    func test_ManagedObjectModel() {
        let request: NSFetchRequest<Person> = Person.fetchRequest()

        guard let person = try? CoreDataManager.shared.managedContext.fetch(request).first else { fatalError() }

        let creator: FlyweightCreator<Person> = FlyweightCreator(className: "PersonFlyweight")
        let flyweight = creator.generate(from: person)

        XCTAssert(flyweight.firstName == "Ralph")
        XCTAssert(flyweight.lastName == "Wiggums")
    }

    func test_ClassModel() {
        let dog = Dog()
        dog.species = "Poodle"
        dog.name = "Scott"

        let creator: FlyweightCreator<Dog> = FlyweightCreator(className: "DogFlyweight")
        let flyweight = creator.generate(from: dog)


        XCTAssert(flyweight.name == "Scott")
        XCTAssert(flyweight.species == "Poodle")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
