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
    
    init(context: NSManagedObjectContext?){
        
        managedObjectContext = context
    }
    
    let bruhaBaseURL: NSURL? = NSURL(string: "http://bruha.com/mobile_php/")
    
    func registerNewUser(completion: (NSString? -> Void)) {
        
        if let registerURL = NSURL(string: "SignUp.php?", relativeToURL: bruhaBaseURL) {
            
            let networkOperation = NetworkOperation(url: registerURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                networkOperation.stringFromURLPost("user_id=TestAccount123&password=S12345678&email=ttttttttt@hotmail.com") {
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