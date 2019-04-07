//
//  Order+CoreDataClass.swift
//  InfoManager
//
//  Created by mac on 4/5/19.
//  Copyright © 2019 mac. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject {
    convenience init() {
        //        NSEntityDescription.entity(forEntityName: "Order", in: persistentContainer.viewContext)
        
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Order"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
