//
//  CredentialCheck.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-07-22.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

class CredentialCheck {
    
    var error :String = "No Error"
    
    func internetCheck() -> String {
        if Reachability.isConnectedToNetwork() == true{
            
            return "true"
        }
        else{
            
            error = "Internet connection could not be established, please connect ensure you are connected to the internet."
        }
        
        return error
    }
    
    func usernameCheck(username:String) -> String{
        if count(username) >= 6 && count(username) <= 20{
            
            let regex = NSRegularExpression(pattern: ".*[^A-Za-z0-9_].*", options: nil, error: nil)!
            
            if regex.firstMatchInString(username, options: nil, range: NSMakeRange(0, count(username))) == nil{
                
                return "true"
            }
            else{
                
                error = "Usernames must only contain letters, numbers, or underscores (_)."
            }
        }
        else{
            
            error = "Usernames must have a length between 6 and 20 characters."
        }
        
        return error
    }
    
    func passwordCheck(password:String) -> String{
        if count(password) >= 8 && count(password) <= 20 {
            
            let characters = NSRegularExpression(pattern: ".*[^A-Za-z0-9_].*", options: nil, error: nil)!
            
            if characters.firstMatchInString(password, options: nil, range: NSMakeRange(0, count(password))) == nil{
                
                let capitalLetterRegEx  = NSRegularExpression(pattern: ".*[A-Z]+.*", options: nil, error: nil)!
                
                if capitalLetterRegEx.firstMatchInString(password, options: nil, range: NSMakeRange(0,count(password))) != nil{
                    
                    return "true"
                }
                else{
                    
                    error = "Passwords must contain at least one capital letter."
                }
                
            }
            else{
                
                error = "Passwords must only contain letters, numbers, or underscores (_)."
            }
            
        }
        else{
            
            error = "Passwords must have a length between 6 and 20 characters."
        }
        
        return error
    }
    
    func emailCheck(email: String) -> String{
        
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if emailTest.evaluateWithObject(email) == true{
            
            return "true"
        }
        else{
            
            error = "Please enter a valid email address."
        }
        
        return error
    }
}