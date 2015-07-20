//
//  OrganizationList.swift
//  BruhaMobile
//
//  Created by The Dad on 2015-07-13.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

// Model for local database object

class OrganizationDBModel: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var location: String
    @NSManaged var orgDescription: String
    @NSManaged var locID: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber

}
