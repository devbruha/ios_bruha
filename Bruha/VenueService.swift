//
//  VenueService.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-10.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

struct VenueService {
    
    let bruhaBaseURL: NSURL? = NSURL(string: "http://bruha.com/mobile_php/")
    
    func getVenue(completion: ([Venue]? -> Void)) {
        
        if let venueURL = NSURL(string: "VenueList.php", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: venueURL)
            
            dispatch_async(dispatch_get_main_queue()) {
            
                networkOperation.downloadJSONFromURL {
                    (let JSONArray) in
                    
                    let mVenue = self.venueFromJSONArray(JSONArray)
                    completion(mVenue)
                }
            }
        } else {
            println("Could not construct a valid URL")
        }
    }
    
    func venueFromJSONArray(jsonArray: NSArray?) -> [Venue]? {
        
        var venues = [Venue]()
        
        for e in jsonArray!{
            
            let e = Venue(venueDictionary: e as! [String : AnyObject])
            
            venues.append(e)
        }
        
        return venues
    }
    
}