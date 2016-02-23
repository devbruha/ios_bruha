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
    
    let organizationID: String
    let organizationName: String
    let organizationDescription: String
    let organizationAddress: String
    
    let primaryCategory: String
    
    //Event location variables
    
    let organizationLatitude: Double
    let organizationLongitude: Double
    
    var posterUrl: String
    
    init(fetchResults: OrganizationDBModel){
        
        organizationID = fetchResults.id
        organizationName = fetchResults.name
        organizationDescription = fetchResults.orgDescription
        organizationAddress = fetchResults.address
        
        primaryCategory = fetchResults.primaryCategory
        
        organizationLatitude = fetchResults.latitude as Double
        organizationLongitude = fetchResults.longitude as Double
        posterUrl = fetchResults.posterUrl
    }
    
    init(fetchUserResults: UserOrganizationDBModel){
        
        organizationID = fetchUserResults.id
        organizationName = fetchUserResults.name
        organizationDescription = fetchUserResults.orgDescription
        organizationAddress = fetchUserResults.address
        
        primaryCategory = fetchUserResults.primaryCategory
        
        organizationLatitude = fetchUserResults.latitude as Double
        organizationLongitude = fetchUserResults.longitude as Double
        posterUrl = fetchUserResults.posterUrl
    }
    
    init(organizationDictionary: [String: AnyObject]) {
        
        //var appt = organizationDictionary["appt"] as! String
        let streetNo = organizationDictionary["street_no"] as! String
        let streetName = organizationDictionary["street_name"] as! String
        var city = organizationDictionary["location_city"] as! String
        let postalCode = organizationDictionary["postal_code"] as! String
        
        organizationAddress = "\(streetNo) \(streetName), \(postalCode)"
        
        organizationName = organizationDictionary["organization_name"] as! String
        
        organizationID = organizationDictionary["organization_id"] as! String
        organizationDescription = organizationDictionary["organization_desc"] as! String
        
        if let categoryName = organizationDictionary["primary_category"] as? String {
            primaryCategory = organizationDictionary["primary_category"] as! String
        } else {
            primaryCategory = ""
            print(primaryCategory)
        }
        
        if let organizationLatString = organizationDictionary["location_lat"] as? String {
            
            let organizationLatNSString = NSString(string: organizationLatString)
            organizationLatitude = organizationLatNSString.doubleValue
            
        } else {
            
            organizationLatitude = 0.0
        }
        
        if let organizationLngString = organizationDictionary["location_lng"] as? String {
            
            let organizationLngNSString = NSString(string: organizationLngString)
            organizationLongitude = organizationLngNSString.doubleValue
            
        } else {
            
            organizationLongitude = 0.0
        }
        
        let tempUrl = organizationDictionary["media"] as! String
        
        posterUrl = "http://www.bruha.com/\(tempUrl)"
    }
}