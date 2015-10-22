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
    
    let userName: String
    let userEmail: String?
    let userCity: String?
    let userFirstName: String?
    let userGender: String?
    let userBirthdate: String?
    
    init(username: String, userEmail: String, userCity: String, userFName: String, userGender: String, userBirthdate: String){
        
        self.userName = username
        self.userEmail = userEmail
        self.userCity = userCity
        self.userFirstName = userFName
        self.userGender = userGender
        self.userBirthdate = userBirthdate
    }
    
    init(fetchResults: UserDBModel){
        
        userName = fetchResults.userName
        userEmail = fetchResults.email
        userCity = fetchResults.city
        userFirstName = fetchResults.firstName
        userGender = fetchResults.gender
        userBirthdate = fetchResults.birthdate
    }
    
    init(userDictionary: [String: AnyObject]) {
        
        userName = userDictionary["Username"] as! String
        userFirstName = userDictionary["Name"] as? String
        userEmail = userDictionary["Email"] as? String
        userCity = userDictionary["City"] as? String
        userGender = userDictionary["Gender"] as? String
        userBirthdate = userDictionary["Birthdate"] as? String
    }
}