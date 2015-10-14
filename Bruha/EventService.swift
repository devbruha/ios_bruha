//
//  EventService.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-07.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

struct EventService {
    
    let bruhaBaseURL: NSURL? = NSURL(string: "http://bruha.com/mobile_php/RetrievePHP/")
    let bruhaUserBaseURL: NSURL? = NSURL(string: "http://bruha.com/mobile_php/RetrieveMyPHP/")
    
    func getEvent(completion: ([Event]? -> Void)) {
        
        if let eventURL = NSURL(string: "EventList.php", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: eventURL)
            
            dispatch_async(dispatch_get_main_queue()) {
            
                networkOperation.downloadJSONFromURL {
                    (let JSONArray) in
                    
                    let mEvent = self.eventFromJSONArray(JSONArray)
                    completion(mEvent)
                }
            }
        } else {
            println("Could not construct a valid URL")
        }
    }
    
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
            println("Could not construct a valid URL")
        }
    }
    
    func getAddictedEvents(completion: ([Event]? -> Void)) {
        
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
            println("Could not construct a valid URL")
        }
    }
    
    func eventFromJSONArray(jsonArray: NSArray?) -> [Event]? {
        
        var events = [Event]()
        
        for e in jsonArray!{
            
            let e = Event(eventDictionary: e as! [String : AnyObject])
            
            events.append(e)
        }
        
        return events
    }
    
}