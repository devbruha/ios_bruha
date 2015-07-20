//
//  UserList.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-07-20.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

// Model for local database object

class UserDBModel: NSManagedObject {

    @NSManaged var userName: String
    @NSManaged var firstName: String
    @NSManaged var email: String
    @NSManaged var city: String
    @NSManaged var gender: String
    @NSManaged var birthdate: String

}
