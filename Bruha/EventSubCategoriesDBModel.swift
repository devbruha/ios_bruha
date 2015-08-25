//
//  EventSubCategories.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-08-19.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

class EventSubCategoriesDBModel: NSManagedObject {

    @NSManaged var primaryCategoryName: String
    @NSManaged var subCategoryID: String
    @NSManaged var subCategoryName: String

}
