//
//  DBModel.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-09.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

// Model for local database object

class EventDBModel: NSManagedObject {
    
    @NSManaged var endDate: String
    @NSManaged var endTime: String
    @NSManaged var eventDescription: String
    @NSManaged var primaryCategory: String
    @NSManaged var subCategoryName: NSArray
    @NSManaged var subCategoryID: NSArray
    @NSManaged var id: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var name: String
    @NSManaged var price: String
    @NSManaged var startDate: String
    @NSManaged var startTime: String
    @NSManaged var venueAddress: String
    @NSManaged var venueCity: String
    @NSManaged var venueID: String
    @NSManaged var venueName: String
    @NSManaged var userID: String
    @NSManaged var posterUrl: String
    @NSManaged var organizationID: NSArray
    
}

