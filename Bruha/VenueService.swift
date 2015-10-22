//
//  VenueService.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-10.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

struct VenueService {
    
    let bruhaBaseURL: NSURL? = NSURL(string: "http://bruha.com/mobile_php/RetrievePHP/")
    let bruhaUserBaseURL: NSURL? = NSURL(string: "http://bruha.com/mobile_php/RetrieveMyPHP/")
    
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
            print("Could not construct a valid URL")
        }
    }
    
    func getUserVenue(completion: ([Venue]? -> Void)) {
        
        if let venueURL = NSURL(string: "UserVenueList.php?", relativeToURL: bruhaUserBaseURL) {
            
            let networkOperation = NetworkOperation(url: venueURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                networkOperation.downloadJSONFromURLPost("username=\(GlobalVariables.username)") {
                    (let JSONArray) in
                    
                    let mVenue = self.venueFromJSONArray(JSONArray)
                    completion(mVenue)
                }
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    func getAddictedVenue(completion: ([String]? -> Void)) {
        
        if let venueURL = NSURL(string: "getVenueAddictions.php?", relativeToURL: bruhaUserBaseURL) {
            
            let networkOperation = NetworkOperation(url: venueURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                networkOperation.downloadJSONFromURLPost("username=\(GlobalVariables.username)") {
                    (let JSONArray) in
                    
                    let addictedVenueIDs = self.stringArrayFromJSONArray(JSONArray)
                    completion(addictedVenueIDs)
                }
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    func addAddictedVenues(venueid: String, completion: (NSString? -> Void)) {
        
        if let eventURL = NSURL(string: "VenueAddictions.php?", relativeToURL: bruhaUserBaseURL) {
            
            let networkOperation = NetworkOperation(url: eventURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                //networkOperation.stringFromURLPost("username=\(self.userName)&password=\(self.passWord)") {
                
                networkOperation.stringFromURLPost("user_id=\(GlobalVariables.username)&venue_id=\(venueid)"){
                    (let addNotice) in
                    completion(addNotice)
                }
                
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    
    func removeAddictedVenues(venueid: String, completion: (NSString? -> Void)) {
        
        if let eventURL = NSURL(string: "deleteVenueAddiction.php?", relativeToURL: bruhaUserBaseURL) {
            
            let networkOperation = NetworkOperation(url: eventURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                networkOperation.stringFromURLPost("user_id=\(GlobalVariables.username)&venue_id=\(venueid)"){
                    (let deleteNotice) in
                    completion(deleteNotice)
                }
                
            }
        } else {
            print("Could not construct a valid URL")
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
    
    func stringArrayFromJSONArray(jsonArray: NSArray?) -> [String]?{
        
        var stringArray = [String]()
        
        for item in jsonArray!{
            
            let venueID = item["venue_id"] as! String
            stringArray.append(venueID)
        }
        
        return stringArray
    }
    
}