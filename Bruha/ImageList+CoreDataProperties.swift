//
//  ImageList+CoreDataProperties.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-11-26.
//  Copyright © 2015 Bruha. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ImageDBModel {

    @NSManaged var id: String?
    @NSManaged var imageData: NSData?

}
