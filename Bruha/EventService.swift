//
//  EventService.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-07.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

struct EventService {
    
    let bruhaBaseURL: NSURL? = NSURL(string: "http://temp.bruha.com/mobile_php/RetrievePHP/")
    let bruhaUserBaseURL: NSURL? = NSURL(string: "http://temp.bruha.com/mobile_php/RetrieveMyPHP/")
    
    //Explore
    
    func getEvent(completion: ([Event]? -> Void)) {
        
        if let eventURL = NSURL(string: "EventList.php", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: eventURL)
            
            dispatch_async(dispatch_get_main_queue()) {
            
                networkOperation.downloadJSONFromURL {
                    (let JSONArray) in
                    //print(JSONArray?.count)
                    let mEvent = self.eventFromJSONArray(JSONArray)
                    completion(mEvent)
                }
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    // My Uploads
    
    func getUserEvents(completion: ([Event]? -> Void)) {
        
        if let eventURL = NSURL(string: "UserEventList.php?", relativeToURL: bruhaUserBaseURL) {
            
            let networkOperation = NetworkOperation(url: eventURL)
            
            dispatch_async(dispatch_get_main_queue()) {
            
                networkOperation.downloadJSONFromURLPost("username=\(GlobalVariables.username)") {
                    (let JSONArray) in
                    
                    let mEvent = self.eventFromJSONArray(JSONArray)
                    completion(mEvent)
                }
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    func removeUserEvents(eventid: String, completion: (NSString? -> Void)) {
        
        if let eventURL = NSURL(string: "deleteUserEvent.php?", relativeToURL: bruhaUserBaseURL) {
            
            let networkOperation = NetworkOperation(url: eventURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                networkOperation.stringFromURLPost("user_id=\(GlobalVariables.username)&event_id=\(eventid)"){
                    (let deleteNotice) in
                    completion(deleteNotice)
                }
                
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    // My Addictions
    
    func getAddictedEvents(completion: ([String]? -> Void)) {
        
        if let eventURL = NSURL(string: "getUserAddiction.php?", relativeToURL: bruhaUserBaseURL) {
            
            let networkOperation = NetworkOperation(url: eventURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                networkOperation.downloadJSONFromURLPost("username=\(GlobalVariables.username)") {
                    (let JSONArray) in
                    
                    let addictedEventIDs = self.stringArrayFromJSONArray(JSONArray)
                    completion(addictedEventIDs)
                }
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    func addAddictedEvents(eventid: String, completion: (NSString? -> Void)) {
        
        if let eventURL = NSURL(string: "EventAddictions.php?", relativeToURL: bruhaUserBaseURL) {
            
            let networkOperation = NetworkOperation(url: eventURL)
            
            dispatch_async(dispatch_get_main_queue()) {
            //networkOperation.stringFromURLPost("username=\(self.userName)&password=\(self.passWord)") {
                
            networkOperation.stringFromURLPost("user_id=\(GlobalVariables.username)&event_id=\(eventid)"){
                (let addNotice) in
                completion(addNotice)
            }
            
            }
        } else {
            print("Could not construct a valid URL")
        }
    }

    
    func removeAddictedEvents(eventid: String, completion: (NSString? -> Void)) {
        
        if let eventURL = NSURL(string: "deleteEventAddiction.php?", relativeToURL: bruhaUserBaseURL) {
            
            let networkOperation = NetworkOperation(url: eventURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                networkOperation.stringFromURLPost("user_id=\(GlobalVariables.username)&event_id=\(eventid)"){
                    (let deleteNotice) in
                    completion(deleteNotice)
                }
    
           }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    func eventFromJSONArray(jsonArray: NSArray?) -> [Event]? {
        
        var events = [Event]()
        
        if(jsonArray == nil){
            
        }
        else{
            
            for e in jsonArray!{
                
                let e = Event(eventDictionary: e as! [String : AnyObject])
                
                events.append(e)
            }
        }
        
        return events
    }
    
    func stringArrayFromJSONArray(jsonArray: NSArray?) -> [String]?{
        
        var stringArray = [String]()
        
        for item in jsonArray!{
        
            let eventID = item["event_id"] as! String
            stringArray.append(eventID)
        }
        
        return stringArray
    }
    
}