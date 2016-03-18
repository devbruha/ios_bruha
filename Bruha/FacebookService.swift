//
//  FacebookService.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-12-02.
//  Copyright © 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

struct FacebookService {
    
    let managedObjectContext: NSManagedObjectContext?
    let userName: String
    let userFName: String
    let emailAddress: String
    let userGender: String
    //let userBirthdate: String

    init(context: NSManagedObjectContext?, username: String, userfname: String, emailaddress:String, usergender: String){
        
        managedObjectContext = context
        userName = username
        userFName = userfname
        emailAddress = emailaddress
        userGender = usergender
    }
    
    let bruhaBaseURL: NSURL? = NSURL(string: "http://temp.bruha.com/mobile_php/CredentialsPHP/")
    
    func registerNewUser(completion: (NSString? -> Void)) {
        
        if let registerURL = NSURL(string: "FacebookSignUp.php", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: registerURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                networkOperation.stringFromURLPost("response_ID=\(self.userName)&response_name=\(self.userFName)&response_email=\(self.emailAddress)&response_gender=\(self.userGender)") {
                    (let registerSignal) in
                    
                    completion(registerSignal)
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
                
                networkOperation.downloadJSONFromURLPost("username=\(self.userName)_FB") {
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
