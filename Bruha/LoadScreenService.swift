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
        
        let eventService = EventService()
        eventService.getUserEvents() {
            (let eventList) in
            
            if let mEvents = eventList{
                
                println(mEvents.count)
                
                SaveData(context: self.managedObjectContext).saveEvents(mEvents)
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
}

