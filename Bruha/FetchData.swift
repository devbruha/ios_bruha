//
//  FetchData.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-09.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

// Each function in this class shall return an Array of items being stored in the relevant table from CoreDate (Local)

class FetchData {
    
    let managedObjectContext: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext?){
        
        self.managedObjectContext = context
    }

    
    func fetchEvents() -> [Event]?{
        
        var returnedEvent: [Event] = [Event]()
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "EventList")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [EventDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let fetchSubRequest = NSFetchRequest(entityName: "EventSubCategoryList")
                let predicate = NSPredicate(format: "eventID == %@", fetchResults[i].id)
                fetchSubRequest.predicate = predicate
                
                if let fetchSubResults = managedObjectContext!.executeFetchRequest(fetchSubRequest, error: nil) as? [EventSubCategoryDBModel]{
                    
        
                    var event = Event(fetchResults: fetchResults[i], fetchSubResults: fetchSubResults)
                    returnedEvent.append(event)
                }
                
            }
            
            return returnedEvent
        }
            
        else {
            return nil
        }
    }
    
    func fetchVenues() -> [Venue]?{
        
        var returnedVenue: [Venue] = [Venue]()
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "VenueList")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [VenueDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                var venue = Venue(fetchResults: fetchResults[i])
                
                returnedVenue.append(venue)
            }
            
            return returnedVenue
        }
        else{
            
            return nil
        }
    }
    
    func fetchArtists() -> [Artist]?{
        
        var returnedArtist: [Artist] = [Artist]()
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "ArtistList")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [ArtistDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                var artist = Artist(fetchResults: fetchResults[i])
                
                returnedArtist.append(artist)
            }
            
            return returnedArtist
            
        }
        else{
            return nil
        }
    }
    
    func fetchOrganizations() -> [Organization]?{
        
        var returnedOrganization: [Organization] = [Organization]()
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "OrganizationList")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [OrganizationDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                var organization = Organization(fetchResults: fetchResults[i])
                
                returnedOrganization.append(organization)
            }
            
            return returnedOrganization
            
        }
        else{
            return nil
        }
    }
    
    func fetchUserInfo() -> [User]?{
        
        var returnedUser: [User] = [User]()
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "UserList")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                var user = User(fetchResults: fetchResults[i])
                
                returnedUser.append(user)
            }
            
            return returnedUser
            
        }
        else{
            return nil
        }
    }
}