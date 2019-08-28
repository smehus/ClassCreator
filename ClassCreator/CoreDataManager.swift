//
//  CoreDataManager.swift
//  ClassCreator
//
//  Created by Scott Mehus on 8/27/19.
//  Copyright © 2019 Scott Mehus. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()

    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ClassCreator")
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard case Optional.none = error else { fatalError() }
        })

        return container
    }()


    func saveContext() {
        guard managedContext.hasChanges else { return }

        do {
            try managedContext.save()
        } catch {
            print("Core Data Save Error: \(error)")
        }
    }

}
