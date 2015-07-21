//
//  LoginService.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-07-20.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

//
//  EventService.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-07.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData


struct LoginService {
    
    let managedObjectContext: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext?){
        
        managedObjectContext = context
    }
    
    let bruhaBaseURL: NSURL? = NSURL(string: "http://bruha.com/mobile_php/")
    
    func loginCheck(completion: (NSString? -> Void)) {
        
        if let loginURL = NSURL(string: "Login.php?", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: loginURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                networkOperation.stringFromURLPost("username=TestAccount&password=12345678") {
                    (let loginSignal) in
                    
                    completion(loginSignal)
                }
            }
        }
        
        else {
            println("Could not construct a valid URL")
        }
    }
    
    func getUserInformation(completion: (User? -> Void)) {
        
        if let userInfoURL = NSURL(string: "UserInfo.php?", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: userInfoURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                println("Retrieve User Info")
                
                networkOperation.downloadJSONFromURLPost("username=TestAccount") {
                    (let JSONArray) in
                    
                    if let mUser = self.userFromNSArray(JSONArray){
                    
                        SaveData(context: self.managedObjectContext).saveUser(mUser)
                        
                        completion(mUser)
                    }
                }
            }
        } else {
            println("Could not construct a valid URL")
        }
    }
    
    func userFromNSArray(jsonArray: NSArray?) -> User? {
        
        var user = User(userDictionary: jsonArray![0] as! [String: AnyObject])
        
        return user
    }
    
}