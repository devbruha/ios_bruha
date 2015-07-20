//
//  Event.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-07.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

// Custom object model

struct Event {
    
    //Event Variables
    
    //let eventIcon: Int?
    
    let eventID: String?
    let eventName: String?
    let eventPrice: String?
    let eventDescription: String?
    let eventStartDate: String?
    let eventStartTime: String?
    let eventEndDate: String?
    let eventEndTime: String?
    //let eventDistance: Double?
    //let eventPicture: Int?
    
    //Event location variables
    
    let locationID: String?
    
    let eventLatitude: Double?
    let eventLongitude: Double?
    
    //Event venue variables
    
    let venueID: String?
    
    let eventVenueName: String?
    let eventVenueAddress: String?
    let eventVenueCity: String?
    
    
    init(eventDictionary: [String: AnyObject]) {
        
        eventPrice = eventDictionary["Admission_price"] as? String
        
        eventName = eventDictionary["event_name"] as? String
        
        eventStartDate = eventDictionary["evnt_start_date"] as? String
        eventEndDate = eventDictionary["event_end_date"] as? String
        eventStartTime = eventDictionary["event_start_time"] as? String
        eventEndTime = eventDictionary["event_end_time"] as? String
        
        eventID = eventDictionary["event_id"] as? String
        eventDescription = eventDictionary["event_desc"] as? String
        
        venueID = eventDictionary["venue_id"] as? String
        locationID = eventDictionary["location_id"] as? String
        
        eventVenueName = eventDictionary["venue_name"] as? String
        eventVenueAddress = eventDictionary["venue_location"] as? String
        eventVenueCity = eventDictionary["location_city"] as? String
        
        if let eventLatString = eventDictionary["location_lat"] as? String {
            
            let eventLatNSString = NSString(string: eventLatString)
            eventLatitude = eventLatNSString.doubleValue
            
        } else {
            
            eventLatitude = nil
        }
        
        if let eventLngString = eventDictionary["location_lng"] as? String {
            
            let eventLngNSString = NSString(string: eventLngString)
            eventLongitude = eventLngNSString.doubleValue
            
        } else {
            
            eventLongitude = nil
        }
        
    }
}