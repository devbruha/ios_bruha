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
    let bruhaUserBaseURL: NSURL? = NSURL(string: "http://bruha.com/mobile_php/RetrieveMyPHP/")
    
    //Explore
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
            print("Could not construct a valid URL")
        }
    }
    
    //My Uploads
    func getUserOrganization(completion: ([Organization]? -> Void)) {
        
        if let organizationURL = NSURL(string: "UserOrgList.php?", relativeToURL: bruhaUserBaseURL) {
            
            let networkOperation = NetworkOperation(url: organizationURL)
            dispatch_async(dispatch_get_main_queue()) {
                
                networkOperation.downloadJSONFromURLPost("username=\(GlobalVariables.username)") {
                    (let JSONArray) in
                    
                    let mOrganization = self.organizationFromJSONArray(JSONArray)
                    completion(mOrganization)
                }
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    func removeUserOrganizations(organizationid: String, completion: (NSString? -> Void)) {
        
        if let organizationURL = NSURL(string: "deleteUserOrg.php?", relativeToURL: bruhaUserBaseURL) {
            
            let networkOperation = NetworkOperation(url: organizationURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                networkOperation.stringFromURLPost("user_id=\(GlobalVariables.username)&organization_id=\(organizationid)"){
                    (let deleteNotice) in
                    completion(deleteNotice)
                }
                
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    //MyAddictions
    
    func getAddictedOrganization(completion: ([String]? -> Void)) {
        
        if let organizationURL = NSURL(string: "getOrgAddictions.php?", relativeToURL: bruhaUserBaseURL) {
            
            let networkOperation = NetworkOperation(url: organizationURL)
            dispatch_async(dispatch_get_main_queue()) {
                
                networkOperation.downloadJSONFromURLPost("username=\(GlobalVariables.username)") {
                    (let JSONArray) in
                    
                    let addictedOrganizationIDs = self.stringArrayFromJSONArray(JSONArray)
                    completion(addictedOrganizationIDs)
                }
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    func addAddictedOrganizations(organizationid: String, completion: (NSString? -> Void)) {
        
        if let organizationURL = NSURL(string: "OrgAddictions.php?", relativeToURL: bruhaUserBaseURL) {
            
            let networkOperation = NetworkOperation(url: organizationURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                //networkOperation.stringFromURLPost("username=\(self.userName)&password=\(self.passWord)") {
                
                networkOperation.stringFromURLPost("user_id=\(GlobalVariables.username)&organization_id=\(organizationid)"){
                    (let addNotice) in
                    completion(addNotice)
                }
                
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    
    func removeAddictedOrganizations(organizationid: String, completion: (NSString? -> Void)) {
        
        if let organizationURL = NSURL(string: "deleteOrgAddiction.php?", relativeToURL: bruhaUserBaseURL) {
            
            let networkOperation = NetworkOperation(url: organizationURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                networkOperation.stringFromURLPost("user_id=\(GlobalVariables.username)&organization_id=\(organizationid)"){
                    (let deleteNotice) in
                    completion(deleteNotice)
                }
                
            }
        } else {
            print("Could not construct a valid URL")
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
    
    func stringArrayFromJSONArray(jsonArray: NSArray?) -> [String]?{
        
        var stringArray = [String]()
        
        for item in jsonArray!{
            
            let organizationID = item["organization_id"] as! String
            stringArray.append(organizationID)
        }
        
        return stringArray
    }
    
}