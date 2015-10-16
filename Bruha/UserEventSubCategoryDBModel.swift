//
//  UserEventSubCategoryList.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-14.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

class UserEventSubCategoryDBModel: NSManagedObject {

    @NSManaged var subCategoryName: String
    @NSManaged var subCategoryID: String
    @NSManaged var eventID: String

}
