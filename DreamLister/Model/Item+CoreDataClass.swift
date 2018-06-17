//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Sagar Duhan on 03/06/18.
//  Copyright © 2018 Sagar Duhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
}
