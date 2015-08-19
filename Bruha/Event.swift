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
    
    var eventID: String
    var eventName: String
    var eventPrice: String?
    var eventDescription: String
    var eventStartDate: String
    var eventStartTime: String
    var eventEndDate: String
    var eventEndTime: String
    
    //Event location variables
    
    var eventLatitude: Double
    var eventLongitude: Double
    
    //Event venue variables
    
    var venueID: String
    
    var eventVenueName: String
    var eventVenueAddress: String
    var eventVenueCity: String
    
    // UserID
    
    var userID: String
    
    //Categories
    
    var primaryCategory: String
    
    var subCategoryName: [String] = []
    var subCategoryID: [String] = []
    
    var posterUrl: String
    
    init(fetchResults: EventDBModel, fetchSubResults: [EventSubCategoryDBModel]){
        
        eventID = fetchResults.id
        eventName = fetchResults.name
        eventPrice = fetchResults.price
        eventDescription = fetchResults.eventDescription
        eventStartDate = fetchResults.startDate
        eventStartTime = fetchResults.startTime
        eventEndDate = fetchResults.endDate
        eventEndTime = fetchResults.endTime
        
        eventLatitude = fetchResults.latitude as Double
        eventLongitude = fetchResults.longitude as Double
        
        venueID = fetchResults.venueID
        eventVenueName = fetchResults.venueName
        eventVenueAddress = fetchResults.venueAddress
        eventVenueCity = fetchResults.venueCity
        
        userID = fetchResults.userID
        
        primaryCategory = fetchResults.primaryCategory
        
        for(var j = 0; j < fetchSubResults.count; ++j){
            
            subCategoryID.append(fetchSubResults[j].subCategoryID as String)
            subCategoryName.append(fetchSubResults[j].subCategoryName as String)
        }
        
        posterUrl = fetchResults.posterUrl
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
        
        eventName = eventDictionary["event_name"] as! String
        
        eventStartDate = eventDictionary["evnt_start_date"] as! String
        eventEndDate = eventDictionary["event_end_date"] as! String
        eventStartTime = eventDictionary["event_start_time"] as! String
        eventEndTime = eventDictionary["event_end_time"] as! String
        
        eventID = eventDictionary["event_id"] as! String
        eventDescription = eventDictionary["event_desc"] as! String
        
        venueID = eventDictionary["venue_id"] as! String
        
        eventVenueName = eventDictionary["venue_name"] as! String
        eventVenueCity = eventDictionary["location_city"] as! String
        
        if let eventLatString = eventDictionary["location_lat"] as? String {
            
            let eventLatNSString = NSString(string: eventLatString)
            eventLatitude = eventLatNSString.doubleValue
            
        } else {
            
            eventLatitude = 0.0
        }
        
        if let eventLngString = eventDictionary["location_lng"] as? String {
            
            let eventLngNSString = NSString(string: eventLngString)
            eventLongitude = eventLngNSString.doubleValue
            
        } else {
            
            eventLongitude = 0.0
        }
        
        userID = eventDictionary["user_id"] as! String
        
        primaryCategory = eventDictionary["primary_category"] as! String
        
        subCategoryName = eventDictionary["sub_category"] as! [String]
        subCategoryID = eventDictionary["sub_category_id"] as! [String]
        
        var tempUrl = eventDictionary["image_link"] as! String
        
        posterUrl = "http://www.bruha.com/WorkingWebsite/\(tempUrl)"
    }
}