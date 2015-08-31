//
//  VenueCategoryListService.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-08-20.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

struct VenueCategoryListService {
    
    let bruhaBaseURL: NSURL? = NSURL(string: "http://bruha.com/mobile_php/RetrievePHP/")
    
    func getEventCategoryList(completion: ([String: [[String]]]? -> Void)) {
        
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
    
    func categoriesFromJSONArray(jsonArray: NSDictionary) -> Dictionary<String, [[String]]> {
        
        var returnedEventCategories = Dictionary<String, [[String]]>()
        
        var eventCategories = jsonArray["event_cat"] as! NSDictionary
        
        var keyset = eventCategories.allKeys as! [String]
        
        for key in keyset{
            
            var eventSubCat = eventCategories[key] as! NSArray
            
            var subCatID = eventSubCat.lastObject as! [String]
            
            var subCatNames: [String] = []
            
            for( var i = 0; i < (eventSubCat.count - 1); ++i ){
                
                subCatNames.append(eventSubCat[i] as! String)
            }
            
            returnedEventCategories[key] = [subCatID, subCatNames]
        }
        
        return returnedEventCategories
    }
}