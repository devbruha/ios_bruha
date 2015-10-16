//
//  LoadScreenService.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-10.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

// Returns [Event] from the remote DB

class LoadScreenService {
    
    let managedObjectContext: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext?){
        
        managedObjectContext = context
    }
    
    func retrieveAll(){
        
        println("Retrieve All")
        
        if(FetchData(context: managedObjectContext).fetchUserInfo()?.count != 0){
            
            GlobalVariables.loggedIn = true
            
            retrieveUserEvents()
            retrieveUserVenues()
            retrieveUserOrganizations()
            
            retrieveAddictedEvents()
            retrieveAddictedVenues()
            retrieveAddictedOrganizations()
            
        }
        else{
            GlobalVariables.loggedIn = false
        }
        
        retrieveEventCategories()
        
        retrieveEvents()
        retrieveVenues()
        retrieveArtists()
        retrieveOrganizations()
        
    }
    
    func retrieveEventCategories(){
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let eventCategoryService = EventCategoryListService()
            eventCategoryService.getEventCategoryList() {
                (let eventCategoryList) in
                
                if let mCategories = eventCategoryList{
                    
                    println("Retrieve Event Categories")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        SaveData(context: self.managedObjectContext).saveCategories(mCategories)
                    }
                }
            }
        }
    }
    
    
    
    // Returns [Event] from the remote DB and saves to local
    
    func retrieveEvents() {
        
        dispatch_async(dispatch_get_main_queue()) {

            let eventService = EventService()
            eventService.getEvent() {
                (let eventList) in
                
                if let mEvents = eventList{
                    
                    println("Retrieve Events")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                    
                        SaveData(context: self.managedObjectContext).saveEvents(mEvents)
                    }
                }
            }
        }
    }
    
    func retrieveUserEvents(){
        
        dispatch_async(dispatch_get_main_queue()) {
        
            let eventService = EventService()
            eventService.getUserEvents() {
                (let eventList) in
                
                if let mEvents = eventList{
                    
                    println("Retrieve User Events")
                    println(mEvents.count)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        SaveData(context: self.managedObjectContext).saveUserEvents(mEvents)
                    }
                }
            }
        }
    }
    
    
    func retrieveAddictedEvents(){
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let eventService = EventService()
            eventService.getAddictedEvents() {
                (let eventList) in
                
                if let mEventIDs = eventList{
                    
                    println("Retrieve Addicted Events")
                    //println(mEventIDs.count)
                    
                    var addictionArray: [AddictionEvent] = []
                    
                    for eventId in mEventIDs{
                        
                        var mAddiction: AddictionEvent = AddictionEvent(eventId: eventId, userId: GlobalVariables.username)
                        
                        addictionArray.append(mAddiction)
                    }
                    
                    //dispatch stuff maybe
                    dispatch_async(dispatch_get_main_queue()) {
                        for addiction in addictionArray{
                        
                            SaveData(context: self.managedObjectContext).saveAddictionEvent(addiction)
                        }
                    }
                }
            }
        }
    }
    
    // Returns [Venue] from the remote DB and saves to local
    
    func retrieveVenues() {
        
        dispatch_async(dispatch_get_main_queue()) {

        let venueService = VenueService()
        venueService.getVenue() {
            (let venueList) in
            
            if let mVenues = venueList{
                
                println("Retrieve Venues")
                dispatch_async(dispatch_get_main_queue()) {
                SaveData(context: self.managedObjectContext).saveVenues(mVenues)
                }
            }
        }
        }
    }
    
    func retrieveUserVenues() {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let venueService = VenueService()
            venueService.getUserVenue() {
                (let venueList) in
                
                if let mVenues = venueList{
                    
                    println("Retrieve User Venues")
                    dispatch_async(dispatch_get_main_queue()) {
                        SaveData(context: self.managedObjectContext).saveUserVenues(mVenues)
                    }
                }
            }
        }
    }
    
    func retrieveAddictedVenues(){
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let venueService = VenueService()
            venueService.getAddictedVenue() {
                (let venueList) in
                
                if let mVenueIDs = venueList{
                    
                    println("Retrieve Addicted Venues")
                    
                    var addictionArray: [AddictionVenue] = []
                    
                    for venueId in mVenueIDs{
                        
                        var mAddiction: AddictionVenue = AddictionVenue(venueId: venueId, userId: GlobalVariables.username)
                        
                        addictionArray.append(mAddiction)
                    }
                    
                    //dispatch stuff maybe
                    dispatch_async(dispatch_get_main_queue()) {
                        for addiction in addictionArray{
                            SaveData(context: self.managedObjectContext).saveAddictionVenue(addiction)
                    
                        }
                    }
                }
            }
        }
    }
    
    
    func retrieveArtists() {
        
        dispatch_async(dispatch_get_main_queue()) {
        
        let artistService = ArtistService()
        artistService.getArtist() {
            (let artistList) in
            
            if let mArtists = artistList{
                
                println("Retrieve Artist")
                dispatch_async(dispatch_get_main_queue()) {
                SaveData(context: self.managedObjectContext).saveArtists(mArtists)
                }
            }
        }
        }
    }
    
    func retrieveOrganizations() {
        
        dispatch_async(dispatch_get_main_queue()) {
    
        let organizationService = OrganizationService()
        organizationService.getOrganization() {
            (let organizationList) in
            
            if let mOrganizations = organizationList{
                
                println("Retrieve Organizations")
                dispatch_async(dispatch_get_main_queue()) {
                SaveData(context: self.managedObjectContext).saveOrganizations(mOrganizations)
                }
            }
        }
        }
    }
    
    func retrieveUserOrganizations() {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let organizationService = OrganizationService()
            organizationService.getUserOrganization() {
                (let organizationList) in
                
                if let mOrganizations = organizationList{
                    
                    println("Retrieve User Organizations")
                    dispatch_async(dispatch_get_main_queue()) {
                        SaveData(context: self.managedObjectContext).saveUserOrganizations(mOrganizations)
                    }
                }
            }
        }
    }
    
    func retrieveAddictedOrganizations(){
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let organizationService = OrganizationService()
            organizationService.getAddictedOrganization() {
                (let organizationList) in
                
                if let mOrganizationIDs = organizationList{
                    
                    println("Retrieve Addicted Organizations")
                    
                    var addictionArray: [AddictionOrganization] = []
                    
                    for organizationId in mOrganizationIDs{
                        
                        var mAddiction: AddictionOrganization = AddictionOrganization(organizationId: organizationId, userId: GlobalVariables.username)
                        
                        addictionArray.append(mAddiction)
                    }
                    
                    //dispatch stuff maybe
                    dispatch_async(dispatch_get_main_queue()) {
                        for addiction in addictionArray{
                        
                            SaveData(context: self.managedObjectContext).saveAddictionOrganization(addiction)
                        }
                    }
                }
            }
        }
    }

}

