//
//  FilterTracker.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-10.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

enum FilterState: String {
    
    case Events = "events"
    case Venues = "venues"
    case Artists = "artists"
    case Organizations = "organizations"
}

class GlobalVariables{
    
    static var currentFilter = FilterState.Events
}