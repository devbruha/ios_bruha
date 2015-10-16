//
//  Addition.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-09-28.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

// Custom object model

struct AddictionEvent {
    let userID: String
    let eventID: String
    
    init(fetchResults: AddictionEventDBModel) {
        userID = fetchResults.userID
        eventID = fetchResults.eventID
        
    }
    
//    init (addictionDictionary: [String: AnyObject]) {
//        userID = addictionDictionary["user_id"] as! String
//        eventID = addictionDictionary["event_id"] as! String
//        
//    }
    
    init (eventId: String, userId: String) {
        userID = userId
        eventID = eventId
        
    }
    
}