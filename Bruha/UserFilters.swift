//
//  UserFilters.swift
//  Bruha
//
//  Created by Ryan O'Neill on 2015-10-01.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation


struct UserFilters{
    
    var dateFilter: [String]
    var categoryFilter: Categories
    var priceFilter: Int
    
    init(dateFilters: [String], categoryFilters: Categories, priceFilters: Int){
        
        dateFilter = dateFilters
        categoryFilter = categoryFilters
        priceFilter = priceFilters
    }
    
    init(){
        
        dateFilter = []
        categoryFilter = Categories()
        priceFilter = 0
    }
}