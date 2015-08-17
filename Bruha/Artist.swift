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
    
    let primaryCategory: String?
    
    init(fetchResults: ArtistDBModel){
        
        artistID = fetchResults.id
        artistName = fetchResults.name
        artistDescription = fetchResults.artistDescription
        primaryCategory = fetchResults.primaryCategory
    }
    
    init(artistDictionary: [String: AnyObject]) {
        
        artistID = artistDictionary["Artist_id"] as? String
        artistName = artistDictionary["Artist_name"] as? String
        artistDescription = artistDictionary["Artist_desc"] as? String
        primaryCategory = artistDictionary["primary_category"] as? String
    
    }
}