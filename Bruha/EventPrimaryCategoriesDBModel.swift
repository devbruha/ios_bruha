//
//  EventPrimaryCategories.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-08-19.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

class EventPrimaryCategoriesDBModel: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var categoryName: String

}
