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
    
    let artistID: String
    let artistName: String
    let artistDescription: String
    
    let primaryCategory: String
    
    var posterUrl: String
    
    init(fetchResults: ArtistDBModel){
        
        artistID = fetchResults.id
        artistName = fetchResults.name
        artistDescription = fetchResults.artistDescription
        primaryCategory = fetchResults.primaryCategory
        posterUrl = fetchResults.posterUrl
    }
    
    init(artistDictionary: [String: AnyObject]) {
        
        artistID = artistDictionary["Artist_id"] as! String
        artistName = artistDictionary["Artist_name"] as! String
        artistDescription = artistDictionary["Artist_desc"] as! String
        
        if let categoryName = artistDictionary["primary_category"] as? String {
            primaryCategory = categoryName
        } else {
            primaryCategory = ""
            println(primaryCategory)
        }
    
        
        var tempUrl = artistDictionary["Artist_media"] as! String
        
        posterUrl = "http://www.bruha.com/WorkingWebsite/\(tempUrl)"
    }
}