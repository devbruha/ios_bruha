//
//  Venue.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-09.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

// Custom object model

struct Venue {
    
    let venueID: String?
    let venueName: String?
    let venueDescription: String?
    let venueAddress: String?
    
    /*
    let venueCategoryIcon: Int?
    let venuePicture: Int?
    
    let contactName: String?
    let contactPhoneNumber: String?
    let contactEmail: String?
    let contactWebsite: String?
    let contactAddress: String?
    */
    
    let venueLatitude: Double?
    let venueLongitude: Double?
    
    
    init(venueDictionary: [String: AnyObject]) {
        
        var appt = venueDictionary["appt"] as? String
        var streetNo = venueDictionary["street_no"] as? String
        var streetName = venueDictionary["street_name"] as? String
        var city = venueDictionary["location_city"] as? String
        var postalCode = venueDictionary["postal_code"] as? String
        
        venueAddress = "\(streetNo!) \(streetName!), \(postalCode!)"
        venueID = venueDictionary["venue_id"] as? String
        venueName = venueDictionary["venue_name"] as?  String
        venueDescription = venueDictionary["venue_desc"] as?  String
        
        /*
        venueCategoryIcon = venueDictionary["location_lat"] as?  Int
        venuePicture = venueDictionary["location_lat"] as?  Int
        
        contactName = venueDictionary["location_lat"] as?  String
        contactPhoneNumber = venueDictionary["location_lat"] as?  String
        contactEmail = venueDictionary["location_lat"] as?  String
        contactWebsite = venueDictionary["location_lat"] as?  String
        contactAddress = venueDictionary["location_lat"] as?  String
        */
        
        
        if let venueLatString = venueDictionary["location_lat"] as? String {
            
            let venueLatNSString = NSString(string: venueLatString)
            venueLatitude = venueLatNSString.doubleValue
            
        } else {
            
            venueLatitude = nil
        }
        
        if let venueLngString = venueDictionary["location_lng"] as? String {
            
            let venueLngNSString = NSString(string: venueLngString)
            venueLongitude = venueLngNSString.doubleValue
            
        } else {
            
            venueLongitude = nil
        }
        
    }
}