//
//  EventCategoryListService.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-08-20.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

struct EventCategoryListService {
    
    let bruhaBaseURL: NSURL? = NSURL(string: "http://bruha.com/mobile_php/RetrievePHP/")
    
    func getEventCategoryList(completion: (Categories? -> Void)) {
        
        if let eventCategoryURL = NSURL(string: "CategoryList.php", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: eventCategoryURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                networkOperation.downloadJSONDictionaryFromURL {
                    (let JSONDictionary) in
                    
                    let mCategories = self.categoriesFromJSONArray(JSONDictionary!)
                    completion(mCategories)
                }
            }
        } else {
            println("Could not construct a valid URL")
        }
    }
    
    func categoriesFromJSONArray(jsonArray: NSDictionary) -> Categories {
        
        //Event Categories

        var returnedEventCategories = Dictionary<String, [[String]]>()
        
        var eventCategories = jsonArray["event_cat"] as! NSDictionary
        
        var eventKeyset = eventCategories.allKeys as! [String]
        
        for key in eventKeyset{
            
            var eventSubCat = eventCategories[key] as! NSArray
            
            var subCatID = eventSubCat.lastObject as! [String]
            
            var subCatNames: [String] = []
            
            for( var i = 0; i < (eventSubCat.count - 1); ++i ){
                
                subCatNames.append(eventSubCat[i] as! String)
            }
            
            returnedEventCategories[key] = [subCatID, subCatNames]
        }
        
        // Venue Categories
        
        var returnedVenueCategories = [String]()
        
        var venueCategories = jsonArray["venue_cat"] as! NSArray
        
        for category in venueCategories{
            
            returnedVenueCategories.append(category as! String)
        }
        
        // Artist Categories
        
        var returnedArtistCategories = [String]()
        
        var artistCategories = jsonArray["artist_cat"] as! NSArray
        
        for category in artistCategories{
            
            returnedArtistCategories.append(category as! String)
        }
        
        // Organization Categories
        
        var returnedOrganizationCategories = [String]()
        
        var organizationCategories = jsonArray["organization_cat"] as! NSArray
        
        for category in organizationCategories{
            
            returnedOrganizationCategories.append(category as! String)
        }
        
        var returnedCategory = Categories(eventCategory: returnedEventCategories, venueCategory: returnedVenueCategories, artistCategory: returnedArtistCategories, organizationCategory: returnedOrganizationCategories)
        
        return returnedCategory
    }
}