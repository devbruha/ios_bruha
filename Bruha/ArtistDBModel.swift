//
//  ArtistList.swift
//  BruhaMobile
//
//  Created by The Dad on 2015-07-13.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

// Model for local database object

class ArtistDBModel: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var artistDescription: String
    @NSManaged var primaryCategory: String
    @NSManaged var posterUrl: String
}
