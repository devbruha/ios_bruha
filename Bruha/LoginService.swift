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
    let userName:String
    let passWord:String
    
    init(context: NSManagedObjectContext?, username: String, password: String){
        
        managedObjectContext = context
        userName = username
        passWord = password
    }
    
    let bruhaBaseURL: NSURL? = NSURL(string: "http://temp.bruha.com/mobile_php/CredentialsPHP/")
    
    func loginCheck(completion: (NSString? -> Void)) {
        
        if let loginURL = NSURL(string: "loginZW.php?", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: loginURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                networkOperation.stringFromURLPost("username=\(self.userName)&password=\(self.passWord)") {

                    (let loginSignal) in
                    
                    completion(loginSignal)
                }
            }
        }
        
        else {
            print("Could not construct a valid URL")
        }
    }
    
    func getUserInformation(completion: (User? -> Void)) {
        
        let userInfoBaseURL: NSURL? = NSURL(string: "http://temp.bruha.com/mobile_php/RetrieveMyPHP/")
        
        if let userInfoURL = NSURL(string: "UserInfo.php?", relativeToURL: userInfoBaseURL) {
            
            let networkOperation = NetworkOperation(url: userInfoURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                print("Retrieve User Info")
                
                networkOperation.downloadJSONFromURLPost("username=\(self.userName)") {
                    (let JSONArray) in
                    
                    if let mUser = self.userFromNSArray(JSONArray){
                        
                        GlobalVariables.username = mUser.userName
                    
                        SaveData(context: self.managedObjectContext).saveUser(mUser)
                        
                        completion(mUser)
                    }
                }
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    func userFromNSArray(jsonArray: NSArray?) -> User? {
        
        let user = User(userDictionary: jsonArray![0] as! [String: AnyObject])
        
        return user
    }
    
}