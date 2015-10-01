//
//  AddictionOrganization.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-01.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

class AddictionOrganizationDBModel: NSManagedObject {

    @NSManaged var userID: String
    @NSManaged var organizationID: String

}
