//
//  OrganizationService.swift
//  BruhaMobile
//
//  Created by The Dad on 2015-07-13.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

struct OrganizationService {
    
    let bruhaBaseURL: NSURL? = NSURL(string: "http://bruha.com/mobile_php/RetrievePHP/")
    
    func getOrganization(completion: ([Organization]? -> Void)) {
        
        if let organizationURL = NSURL(string: "OrganizationList.php", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: organizationURL)
            dispatch_async(dispatch_get_main_queue()) {
            
                networkOperation.downloadJSONFromURL {
                    (let JSONArray) in
                    
                    let mOrganization = self.organizationFromJSONArray(JSONArray)
                    completion(mOrganization)
                }
            }
        } else {
            println("Could not construct a valid URL")
        }
    }
    
    func organizationFromJSONArray(jsonArray: NSArray?) -> [Organization]? {
        
        var organizations = [Organization]()
        
        for e in jsonArray!{
            
            let e = Organization(organizationDictionary: e as! [String : AnyObject])
            
            organizations.append(e)
        }
        
        return organizations
    }
    
}