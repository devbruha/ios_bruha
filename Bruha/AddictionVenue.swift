//
//  AddictionVenue.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-01.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

// Custom object model

struct AddictionVenue {
    let userID: String
    let venueID: String
    
    init(fetchResults: AddictionEventDBModel) {
        userID = fetchResults.userID
        venueID = fetchResults.eventID
        
    }
    
    init (addictionDictionary: [String: AnyObject]) {
        userID = addictionDictionary["user_id"] as! String
        venueID = addictionDictionary["artist_id"] as! String
        
    }
    
    init (venueId: String, userId: String) {
        userID = userId
        venueID = venueId
        
    }
    
}