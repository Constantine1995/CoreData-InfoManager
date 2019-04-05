//
//  RowOfOrder+CoreDataClass.swift
//  InfoManager
//
//  Created by mac on 4/5/19.
//  Copyright © 2019 mac. All rights reserved.
//
//

import Foundation
import CoreData

@objc(RowOfOrder)
public class RowOfOrder: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "RowOfOrder"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
