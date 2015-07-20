//
//  Organizations.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-09.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

struct Organization {
    
    //Event Variables
    
    //let eventIcon: Int?
    
    let organizationID: String?
    let organizationName: String?
    let organizationDescription: String?
    let organizationLocation: String?
    
    //Event location variables
    
    let locationID: String?
    
    let organizationLatitude: Double?
    let organizationLongitude: Double?
    
    init(organizationDictionary: [String: AnyObject]) {
        
        organizationName = organizationDictionary["organization_name"] as? String
        
        organizationID = organizationDictionary["organization_id"] as? String
        organizationDescription = organizationDictionary["organization_desc"] as? String
        
        organizationLocation = organizationDictionary["organization_location"] as? String
        
        locationID = organizationDictionary["location_id"] as? String
        
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