//
//  Person+CoreDataProperties.swift
//  ClassCreator
//
//  Created by Scott Mehus on 8/27/19.
//  Copyright © 2019 Scott Mehus. All rights reserved.
//
//

import Foundation
import CoreData


@objc extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
}
