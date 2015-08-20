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
    
    func getEventCategoryList(completion: ([String: [[String]]]? -> Void)) {
        
        if let eventCategoryURL = NSURL(string: "CategoryList.php", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: eventCategoryURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                networkOperation.downloadJSONDictionnaryFromURL {
                    (let JSONArray) in
                    
                    let mEventCategories = self.eventCategoriesFromJSONDictionary(JSONArray)
                    completion(mEventCategories)
                }
            }
        } else {
            println("Could not construct a valid URL")
        }
    }
    
    func eventCategoriesFromJSONDictionary(jsonDictionary: NSDictionary?) -> [String: [[String]]]? {
        
        var count = 0
        
        var eventCategories = [String: [[String]]]()
        
        for catType in jsonDictionary!{
            
            if(catType.0 as! String == "event_cat"){
                
                var eventCat = catType.value as! NSArray
                
                for primaryCatAny in eventCat{
                    
                    var primaryCat = primaryCatAny as! NSDictionary
                    
                    //var subCatName = primaryCat.1 as! [String]
                    //subCatName.removeLast()
                    //var subCatID = primaryCat.1[primaryCat.1.count-1] as! [String]
                    
                    //eventCategories[primaryCat.0] = [subCatID,subCatName]
                }
            }
            
            ++count

        }
        
        return eventCategories
    }
    
}