//
//  AddictionOrganization.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-01.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

// Custom object model

struct AddictionOrganization {
    let userID: String
    let organizationID: String
    
    init(fetchResults: AddictionEventDBModel) {
        userID = fetchResults.userID
        organizationID = fetchResults.eventID
        
    }
    
    init (addictionDictionary: [String: AnyObject]) {
        userID = addictionDictionary["user_id"] as! String
        organizationID = addictionDictionary["artist_id"] as! String
        
    }
    
    init (organizationId: String, userId: String) {
        userID = userId
        organizationID = organizationId
        
    }
    
}