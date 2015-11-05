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
    
    func retrieveUser() {
        
        retrieveUserEvents()
        retrieveUserVenues()
        retrieveUserOrganizations()
        
        retrieveAddictedEvents()
        retrieveAddictedVenues()
        retrieveAddictedOrganizations()
    }
    
    func retrieveAll(){
        
        print("Retrieve All")
        
        if(FetchData(context: managedObjectContext).fetchUserInfo()?.count != 0){
            
            GlobalVariables.loggedIn = true
            
            retrieveUser()
            
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
                    
                    print("Retrieve Event Categories")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        SaveData(context: self.managedObjectContext).saveCategories(mCategories)
                        NSNotificationCenter.defaultCenter().postNotificationName("Event Categories", object: nil)
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
                    
                    print("Retrieve Events")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                    
                        SaveData(context: self.managedObjectContext).saveEvents(mEvents)
                        NSNotificationCenter.defaultCenter().postNotificationName("Events", object: nil)
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
                    
                    print("Retrieve User Events")
                    print(mEvents.count)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        SaveData(context: self.managedObjectContext).saveUserEvents(mEvents)
                        NSNotificationCenter.defaultCenter().postNotificationName("User Events", object: nil)
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
                    
                    print("Retrieve Addicted Events")
                    //println(mEventIDs.count)
                    
                    var addictionArray: [AddictionEvent] = []
                    
                    for eventId in mEventIDs{
                        
                        let mAddiction: AddictionEvent = AddictionEvent(eventId: eventId, userId: GlobalVariables.username)
                        
                        addictionArray.append(mAddiction)
                    }
                    
                    //dispatch stuff maybe
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        for addiction in addictionArray{
                            SaveData(context: self.managedObjectContext).saveAddictionEvent(addiction)
                        }
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("Addicted Events", object: nil)
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
                
                print("Retrieve Venues")
                dispatch_async(dispatch_get_main_queue()) {
                    SaveData(context: self.managedObjectContext).saveVenues(mVenues)
                    NSNotificationCenter.defaultCenter().postNotificationName("Venues", object: nil)
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
                    
                    print("Retrieve User Venues")
                    dispatch_async(dispatch_get_main_queue()) {
                        SaveData(context: self.managedObjectContext).saveUserVenues(mVenues)
                        NSNotificationCenter.defaultCenter().postNotificationName("User Venues", object: nil)
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
                    
                    print("Retrieve Addicted Venues")
                    
                    var addictionArray: [AddictionVenue] = []
                    
                    for venueId in mVenueIDs{
                        
                        let mAddiction: AddictionVenue = AddictionVenue(venueId: venueId, userId: GlobalVariables.username)
                        
                        addictionArray.append(mAddiction)
                    }
                    
                    //dispatch stuff maybe
                    dispatch_async(dispatch_get_main_queue()) {
                        for addiction in addictionArray{
                            SaveData(context: self.managedObjectContext).saveAddictionVenue(addiction)
                    
                        }
                        NSNotificationCenter.defaultCenter().postNotificationName("Addicted Venues", object: nil)
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
                
                print("Retrieve Artist")
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
                
                print("Retrieve Organizations")
                dispatch_async(dispatch_get_main_queue()) {
                    SaveData(context: self.managedObjectContext).saveOrganizations(mOrganizations)
                    NSNotificationCenter.defaultCenter().postNotificationName("Organizations", object: nil)
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
                    
                    print("Retrieve User Organizations")
                    dispatch_async(dispatch_get_main_queue()) {
                        SaveData(context: self.managedObjectContext).saveUserOrganizations(mOrganizations)
                        NSNotificationCenter.defaultCenter().postNotificationName("User Organizations", object: nil)
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
                    
                    print("Retrieve Addicted Organizations")
                    
                    var addictionArray: [AddictionOrganization] = []
                    
                    for organizationId in mOrganizationIDs{
                        
                        let mAddiction: AddictionOrganization = AddictionOrganization(organizationId: organizationId, userId: GlobalVariables.username)
                        
                        addictionArray.append(mAddiction)
                    }
                    
                    //dispatch stuff maybe
                    dispatch_async(dispatch_get_main_queue()) {
                        for addiction in addictionArray{
                        
                            SaveData(context: self.managedObjectContext).saveAddictionOrganization(addiction)
                        }
                        NSNotificationCenter.defaultCenter().postNotificationName("Addicted Organizations", object: nil)
                    }
                }
            }
        }
    }

}

