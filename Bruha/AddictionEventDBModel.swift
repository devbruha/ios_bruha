//
//  Addiction.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-09-28.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

class AddictionEventDBModel: NSManagedObject {

    @NSManaged var userID: String
    @NSManaged var eventID: String

}
