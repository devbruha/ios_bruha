//
//  UserVenueList.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-14.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

class UserVenueDBModel: NSManagedObject {

    @NSManaged var venueDescription: String
    @NSManaged var primaryCategory: String
    @NSManaged var posterUrl: String
    @NSManaged var name: String
    @NSManaged var longitude: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var id: String
    @NSManaged var address: String

}
