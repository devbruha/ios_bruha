//
//  EventSubCategoryList.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-08-12.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

class EventSubCategoryDBModel: NSManagedObject {

    @NSManaged var eventID: String
    @NSManaged var subCategoryName: String
    @NSManaged var subCategoryID: String

}
