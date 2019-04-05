//
//  RowOfOrder+CoreDataProperties.swift
//  InfoManager
//
//  Created by mac on 4/5/19.
//  Copyright © 2019 mac. All rights reserved.
//
//

import Foundation
import CoreData


extension RowOfOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RowOfOrder> {
        return NSFetchRequest<RowOfOrder>(entityName: "RowOfOrder")
    }

    @NSManaged public var sum: Float
    @NSManaged public var order: Order?
    @NSManaged public var service: Services?
}
