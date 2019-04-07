//
//  Services+CoreDataClass.swift
//  InfoManager
//
//  Created by mac on 4/5/19.
//  Copyright © 2019 mac. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Services)
public class Services: NSManagedObject {
    convenience init() {
//        NSEntityDescription.entity(forEntityName: "Services", in: persistentContainer.viewContext)!\

        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Services"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
