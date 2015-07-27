//
//  User.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-07-20.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

// Custom object model

struct User {
    
    //User Variables
    
    let userName: String?
    let userEmail: String?
    let userCity: String?
    let userFirstName: String?
    let userGender: String?
    let userBirthdate: String?
    
    init(userDictionary: [String: AnyObject]) {
        
        userName = userDictionary["Username"] as? String
        userFirstName = userDictionary["Name"] as? String
        userEmail = userDictionary["Email"] as? String
        userCity = userDictionary["City"] as? String
        userGender = userDictionary["Gender"] as? String
        userBirthdate = userDictionary["Birthdate"] as? String
    }
}