//
//  FilterTracker.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-10.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation

public enum FilterState: String {
    
    case Events = "events"
    case Venues = "venues"
    case Artists = "artists"
    case Organizations = "organizations"
}

class GlobalVariables{
    
    static var currentFilter = FilterState.Events
    static var eventSelected = "999999"
    
    static var selectedDisplay = "Event"
    static var addictedDisplay = "Event"
    static var uploadDisplay = "Event"
    
    static var loggedIn = false
    static var username = ""
    
    static var categories: Categories = Categories()
    
    static var displayedEvents: [Event] = []
    static var displayedVenues: [Venue] = []
    static var displayedArtists: [Artist] = []
    static var displayedOrganizations: [Organization] = []
    
    static var UserCustomFilters: UserFilters = UserFilters()
    
    static var displayFilteredEvents: [Event] = []
    static var displayFilteredVenues: [Venue] = []
    static var displayFilteredOrganizations: [Organization] = []
    static var filterEventBool = false
    static var filterVenueBool = false
    static var filterOrganizationBool = false
    
    static var datesSelected = NSMutableArray()
    
    static var eventImageCache = OrderedDictionary<String, UIImage>()
    static var venueImageCache = OrderedDictionary<String, UIImage>()
    static var organizationImageCache = OrderedDictionary<String, UIImage>()
    
}