//
//  ArtistService.swift
//  BruhaMobile
//
//  Created by The Dad on 2015-07-13.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

struct ArtistService {
    
    let bruhaBaseURL: NSURL? = NSURL(string: "http://bruha.com/mobile_php/")
    
    func getArtist(completion: ([Artist]? -> Void)) {
        
        if let artistURL = NSURL(string: "ArtistList.php", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: artistURL)
            
            dispatch_async(dispatch_get_main_queue()) {
            
                networkOperation.downloadJSONFromURL {
                    (let JSONArray) in
                    
                    let mArtist = self.artistFromJSONArray(JSONArray)
                    completion(mArtist)
                }
            }
        } else {
            println("Could not construct a valid URL")
        }
    }
    
    func artistFromJSONArray(jsonArray: NSArray?) -> [Artist]? {
        
        var artists = [Artist]()
        
        for e in jsonArray!{
            
            let e = Artist(artistDictionary: e as! [String : AnyObject])
            
            artists.append(e)
        }
        
        return artists
    }
    
}