//
//  Artist.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-09.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

// Custom object model

struct Artist {
    
    let artistID: String?
    let artistName: String?
    let artistDescription: String?
    
    //let artistEventID: Int?
    
    //let artistPicture: Int?
    //let artistIcon: Int?
    
    /*
    let contactName: String?
    let contactPhoneNumber: String?
    let contactEmail: String?
    let contactWebsite: String?
    let contactAddress: String?
    */
    
    init(artistDictionary: [String: AnyObject]) {
        
        artistID = artistDictionary["Artist_id"] as? String
        artistName = artistDictionary["Artist_name"] as? String
        artistDescription = artistDictionary["Artist_desc"] as? String
    
    }
}