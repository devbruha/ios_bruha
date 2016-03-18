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
    var organizationID: [String] = []
    
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
        
        
        organizationID = fetchResults.organizationID as! [String]
        
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
    
    init(fetchUserResults: UserEventDBModel, fetchUserSubResults: [UserEventSubCategoryDBModel]){
        
        eventID = fetchUserResults.id
        eventName = fetchUserResults.name
        eventPrice = fetchUserResults.price
        eventDescription = fetchUserResults.eventDescription
        eventStartDate = fetchUserResults.startDate
        eventStartTime = fetchUserResults.startTime
        eventEndDate = fetchUserResults.endDate
        eventEndTime = fetchUserResults.endTime
        
        eventLatitude = fetchUserResults.latitude as Double
        eventLongitude = fetchUserResults.longitude as Double
        
        organizationID = fetchUserResults.organizationID as! [String]
        
        venueID = fetchUserResults.venueID
        eventVenueName = fetchUserResults.venueName
        eventVenueAddress = fetchUserResults.venueAddress
        eventVenueCity = fetchUserResults.venueCity
        
        userID = GlobalVariables.username
        
        primaryCategory = fetchUserResults.primaryCategory
        
        for(var j = 0; j < fetchUserSubResults.count; ++j){
            
            subCategoryID.append(fetchUserSubResults[j].subCategoryID as String)
            subCategoryName.append(fetchUserSubResults[j].subCategoryName as String)
        }
        
        posterUrl = fetchUserResults.posterUrl
    }

    
    init(eventDictionary: [String: AnyObject]) {
        
        var appt = eventDictionary["appt"] as? String
        let streetNo = eventDictionary["street_no"] as? String
        let streetName = eventDictionary["street_name"] as? String
        var city = eventDictionary["location_city"] as? String
        let postalCode = eventDictionary["postal_code"] as? String
        
        eventVenueAddress = "\(streetNo!) \(streetName!), \(postalCode!)"
        
        if let admission = eventDictionary["Admission_price"] as? String{
            
            eventPrice = admission
        }
        else{
            eventPrice = "0.00"
        }
        
        eventName = eventDictionary["event_name"] as! String
        
        eventStartDate = eventDictionary["event_start_date"] as! String
        eventEndDate = eventDictionary["event_end_date"] as! String
        eventStartTime = eventDictionary["event_start_time"] as! String
        eventEndTime = eventDictionary["event_end_time"] as! String
        
        eventID = eventDictionary["event_id"] as! String
        eventDescription = eventDictionary["event_desc"] as! String
        
        if let organizationIDString = eventDictionary["organization_id"] as? [String] {
            organizationID = organizationIDString
        }else {
            organizationID = []
        }
        
        if let venueIDString = eventDictionary["venue_id"] as? String {
            venueID = venueIDString
        }else {
            venueID = ""
        }
        
        if let eventVenueNameString = eventDictionary["venue_name"] as? String {
            eventVenueName = eventVenueNameString
        } else {
            eventVenueName = ""
        }
        
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
        
        if let userString = eventDictionary["user_id"] as? String{
            
            userID = userString
        }
        else{
            
            userID = GlobalVariables.username
        }
        
        if let categoryName = eventDictionary["primary_category"] as? String {
            primaryCategory = categoryName
        } else {
            primaryCategory = ""
            print(primaryCategory)
        }
        
        subCategoryName = eventDictionary["sub_category"] as! [String]
        subCategoryID = eventDictionary["sub_category_id"] as! [String]
        
        let tempUrl = eventDictionary["image_link"] as! String
        posterUrl = "http://temp.bruha.com/\(tempUrl)"
    }
}