//
//  VenueList.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-10.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

// Model for local database object

class VenueDBModel: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var id: String
    @NSManaged var venueDescription: String
    @NSManaged var primaryCategory: String
    @NSManaged var address: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    
}

