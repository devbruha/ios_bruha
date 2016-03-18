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
    
    let venueID: String
    let venueName: String
    let venueDescription: String
    let venueAddress: String
    
    let primaryCategory: String
    
    let venueLatitude: Double
    let venueLongitude: Double
    
    var posterUrl: String
    
    init(fetchResults: VenueDBModel){
        
        venueID = fetchResults.id
        venueName = fetchResults.name
        venueDescription = fetchResults.venueDescription
        venueAddress = fetchResults.address
        primaryCategory = fetchResults.primaryCategory
        venueLatitude = fetchResults.latitude as Double
        venueLongitude = fetchResults.longitude as Double
        posterUrl = fetchResults.posterUrl
    }
    
    init(fetchUserResults: UserVenueDBModel){
        
        venueID = fetchUserResults.id
        venueName = fetchUserResults.name
        venueDescription = fetchUserResults.venueDescription
        venueAddress = fetchUserResults.address
        primaryCategory = fetchUserResults.primaryCategory
        venueLatitude = fetchUserResults.latitude as Double
        venueLongitude = fetchUserResults.longitude as Double
        posterUrl = fetchUserResults.posterUrl
    }
    
    init(venueDictionary: [String: AnyObject]) {
        
        var appt = venueDictionary["appt"] as! String
        let streetNo = venueDictionary["street_no"] as! String
        let streetName = venueDictionary["street_name"] as! String
        var city = venueDictionary["location_city"] as! String
        let postalCode = venueDictionary["postal_code"] as! String
        let province = venueDictionary["state"] as! String
        let country = venueDictionary["country"] as! String
        
        venueAddress = "\(streetNo) \(streetName), \(city) \(province), \(country)"
        venueID = venueDictionary["venue_id"] as! String
        venueName = venueDictionary["venue_name"] as!  String
        venueDescription = venueDictionary["venue_desc"] as!  String
        
        
        if let venueLatString = venueDictionary["location_lat"] as? String {
            
            let venueLatNSString = NSString(string: venueLatString)
            venueLatitude = venueLatNSString.doubleValue
            
        } else {
            
            venueLatitude = 0.0
        }
        
        if let venueLngString = venueDictionary["location_lng"] as? String {
            
            let venueLngNSString = NSString(string: venueLngString)
            venueLongitude = venueLngNSString.doubleValue
            
        } else {
            
            venueLongitude = 0.0
        }
        
        if let categoryName = venueDictionary["primary_category"] as? String {
            primaryCategory = categoryName
        } else {
            primaryCategory = ""
            print(primaryCategory)
        }
        
        let tempUrl = venueDictionary["media"] as! String
        
        posterUrl = "http://temp.bruha.com/\(tempUrl)"
        
    }
}