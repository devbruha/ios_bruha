//
//  UserEventList.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-14.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

class UserEventDBModel: NSManagedObject {

    @NSManaged var venueName: String
    @NSManaged var venueID: String
    @NSManaged var venueCity: String
    @NSManaged var venueAddress: String
    @NSManaged var subCategoryName: NSData
    @NSManaged var subCategoryID: NSData
    @NSManaged var startTime: String
    @NSManaged var startDate: String
    @NSManaged var primaryCategory: String
    @NSManaged var price: String
    @NSManaged var posterUrl: String
    @NSManaged var name: String
    @NSManaged var longitude: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var id: String
    @NSManaged var eventDescription: String
    @NSManaged var endTime: String
    @NSManaged var endDate: String
    @NSManaged var organizationID: String

}
