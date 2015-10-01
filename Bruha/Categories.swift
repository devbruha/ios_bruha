//
//  Categories.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-08-25.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

// Custom object model

struct Categories {
    
    //User Variables
    
    let eventCategories: Dictionary<String, [[String]]>
    let venueCategories: [String]
    let artistCategories: [String]
    let organizationCategories: [String]
    
    init(eventCategory: Dictionary<String, [[String]]>, venueCategory: [String], artistCategory: [String], organizationCategory: [String]) {
        
        eventCategories = eventCategory
        venueCategories = venueCategory
        artistCategories = artistCategory
        organizationCategories = organizationCategory
    }
}