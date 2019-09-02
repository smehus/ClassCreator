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

        ivars()
        properties()
    }
}

extension ViewController {
    private func properties() {

        let request: NSFetchRequest<Person> = Person.fetchRequest()

        guard let person = try? CoreDataManager.shared.managedContext.fetch(request).first else { fatalError() }

        let creator: FlyweightCreator<Person> = FlyweightCreator(className: "PersonFlyweight")
        let flyweight = creator.generate(from: person)

        print("firstName: \(String(describing: flyweight.firstName)) lastName: \(String(describing: flyweight.lastName))")

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

        print("name: \(String(describing: flyweight.name)) species: \(String(describing: flyweight.species))")
    }
}
