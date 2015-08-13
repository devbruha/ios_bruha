//
//  Organizations.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-09.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

// Custom object model

struct Organization {
    
    //Event Variables
    
    let organizationID: String?
    let organizationName: String?
    let organizationDescription: String?
    let organizationAddress: String?
    
    let primaryCategory: String?
    
    //Event location variables
    
    let organizationLatitude: Double?
    let organizationLongitude: Double?
    
    init(organizationDictionary: [String: AnyObject]) {
        
        var appt = organizationDictionary["appt"] as? String
        var streetNo = organizationDictionary["street_no"] as? String
        var streetName = organizationDictionary["street_name"] as? String
        var city = organizationDictionary["location_city"] as? String
        var postalCode = organizationDictionary["postal_code"] as? String
        
        organizationAddress = "\(streetNo!) \(streetName!), \(postalCode!)"
        
        organizationName = organizationDictionary["organization_name"] as? String
        
        organizationID = organizationDictionary["organization_id"] as? String
        organizationDescription = organizationDictionary["organization_desc"] as? String
        
        primaryCategory = organizationDictionary["primary_category"] as? String
        
        
        if let organizationLatString = organizationDictionary["location_lat"] as? String {
            
            let organizationLatNSString = NSString(string: organizationLatString)
            organizationLatitude = organizationLatNSString.doubleValue
            
        } else {
            
            organizationLatitude = nil
        }
        
        if let organizationLngString = organizationDictionary["location_lng"] as? String {
            
            let organizationLngNSString = NSString(string: organizationLngString)
            organizationLongitude = organizationLngNSString.doubleValue
            
        } else {
            
            organizationLongitude = nil
        }
        
    }
}