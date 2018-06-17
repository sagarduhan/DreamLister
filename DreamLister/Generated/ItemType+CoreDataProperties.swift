//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Sagar Duhan on 03/06/18.
//  Copyright © 2018 Sagar Duhan. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
