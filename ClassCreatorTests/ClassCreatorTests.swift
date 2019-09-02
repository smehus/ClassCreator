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
        super.setUp()

        let context = CoreDataManager.shared.managedContext
        let person = Person(context: context)
        person.firstName = "Ralph"
        person.lastName = "Wiggums"

        CoreDataManager.shared.saveContext()

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
            print("what is this?")
        }
    }

}
