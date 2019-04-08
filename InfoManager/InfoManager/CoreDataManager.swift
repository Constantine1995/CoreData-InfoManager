//
//  CoreDataManager.swift
//  InfoManager
//
//  Created by mac on 4/5/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
//    // Singleton
    static let instance = CoreDataManager()

    private init(){}

    lazy var managedObjectContext: NSManagedObjectContext = {
        return CoreDataManager.instance.persistentContainer.viewContext
    }()

    // Entity for Name
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
    }
    
    // MARK: - Core Data stack
    
    lazy  var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "InfoManager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
