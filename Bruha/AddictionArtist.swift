//
//  AddictionArtist.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-01.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

// Custom object model

struct AddictionArtist {
    let userID: String
    let artistID: String
    
    init(fetchResults: AddictionArtistDBModel) {
        userID = fetchResults.userID
        artistID = fetchResults.artistID
        
    }
    
//    init (addictionDictionary: [String: AnyObject]) {
//        userID = addictionDictionary["user_id"] as! String
//        artistID = addictionDictionary["artist_id"] as! String
//        
//    }
    
    init (artistId: String, userId: String) {
        userID = userId
        artistID = artistId
        
    }
    
}