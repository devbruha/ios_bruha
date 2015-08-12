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
    
    var eventID: String?
    var eventName: String?
    var eventPrice: String?
    var eventDescription: String?
    var eventStartDate: String?
    var eventStartTime: String?
    var eventEndDate: String?
    var eventEndTime: String?
    
    //Event location variables
    
    var eventLatitude: Double?
    var eventLongitude: Double?
    
    //Event venue variables
    
    var venueID: String?
    
    var eventVenueName: String?
    var eventVenueAddress: String?
    var eventVenueCity: String?
    
    // UserID
    
    var userID: String?
    
    //Categories
    
    var primaryCategory: String?
    
    var subCategoryName: [String]?
    var subCategoryID: [String]?
    
    init(){
        
        eventID = "0"
        eventVenueAddress = "0"
        eventPrice = "0"
        eventName = "0"
        eventStartDate = "0"
        eventStartTime = "0"
        eventEndDate = "0"
        eventEndTime = "0"
        eventDescription = "0"
        
        eventLatitude = 0.00
        eventLongitude = 0.00
        
        venueID = "0"
        eventVenueName = "0"
        eventVenueCity = "0"
        
        userID = "0"
        
        primaryCategory = "0"
        
        subCategoryID = []
        subCategoryName = []
    }

    
    init(eventDictionary: [String: AnyObject]) {
        
        var appt = eventDictionary["appt"] as? String
        var streetNo = eventDictionary["street_no"] as? String
        var streetName = eventDictionary["street_name"] as? String
        var city = eventDictionary["location_city"] as? String
        var postalCode = eventDictionary["postal_code"] as? String
        
        eventVenueAddress = "\(streetNo!) \(streetName!), \(postalCode!)"
        
        if let admission = eventDictionary["Admission_price"] as? String{
            
            eventPrice = admission
        }
        else{
            eventPrice = "0.00"
        }
        
        eventName = eventDictionary["event_name"] as? String
        
        eventStartDate = eventDictionary["evnt_start_date"] as? String
        eventEndDate = eventDictionary["event_end_date"] as? String
        eventStartTime = eventDictionary["event_start_time"] as? String
        eventEndTime = eventDictionary["event_end_time"] as? String
        
        eventID = eventDictionary["event_id"] as? String
        eventDescription = eventDictionary["event_desc"] as? String
        
        venueID = eventDictionary["venue_id"] as? String
        
        eventVenueName = eventDictionary["venue_name"] as? String
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
        
        userID = eventDictionary["user_id"] as? String
        
        primaryCategory = eventDictionary["primary_category"] as? String
        
        subCategoryName = eventDictionary["sub_category"] as? [String]
        subCategoryID = eventDictionary["sub_category_id"] as? [String]
    }
}