//
//  RegisterService.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-07-21.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

struct RegisterService{
    
    let managedObjectContext: NSManagedObjectContext?
    let userName:String
    let passWord:String
    let emailAddress:String

    
    init(context: NSManagedObjectContext?, username: String, password: String, emailaddress:String){
        
        managedObjectContext = context
        userName = username
        passWord = password
        emailAddress = emailaddress
    }
    
    let bruhaBaseURL: NSURL? = NSURL(string: "http://bruha.com/mobile_php/CredentialsPHP/")
    
    func registerNewUser(completion: (NSString? -> Void)) {
        
        if let registerURL = NSURL(string: "SignUp.php?", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: registerURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                networkOperation.stringFromURLPost("user_id=\(self.userName)&password=\(self.passWord)&email=\(self.emailAddress)") {
                    (let registerSignal) in
                    
                    completion(registerSignal)
                }
            }
        }
            
        else {
            println("Could not construct a valid URL")
        }
    }
}