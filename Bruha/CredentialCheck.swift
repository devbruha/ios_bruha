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
        if username.characters.count >= 1 && username.characters.count <= 20{
            
            let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9_].*", options: [])
            
            if regex.firstMatchInString(username, options: [], range: NSMakeRange(0, username.characters.count)) == nil{
                
                return "true"
            }
            else{
                
                error = "Usernames must only contain letters, numbers, or underscores (_)."
            }
        }
        else{
            
            error = "Usernames must have a length between 1 and 20 characters."
        }
        
        return error
    }
    
    func passwordCheck(password:String) -> String{
        if password.characters.count >= 8 && password.characters.count <= 20 {
            
            let characters = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9_].*", options: [])
            
            if characters.firstMatchInString(password, options: [], range: NSMakeRange(0, password.characters.count)) == nil{
                
                var numberCheck = false
                let passwordArray = [Character](password.characters)
                
                for character in passwordArray{
                    
                    if(Int(String(character)) != nil){
                        numberCheck = true
                    }
                }
                
                if (numberCheck){
                    
                    return "true"
                }
                else{
                    
                    error = "Passwords must contain at least one number."
                }
                
            }
            else{
                
                error = "Passwords must only contain letters, numbers, or underscores (_)."
            }
            
        }
        else{
            
            error = "Passwords must have a length between 8 and 20 characters."
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