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
                
                var event = Event()
                
                event.eventID = fetchResults[i].id
                event.eventName = fetchResults[i].name
                event.eventPrice = fetchResults[i].price
                event.eventDescription = fetchResults[i].eventDescription
                event.eventStartDate = fetchResults[i].startDate
                event.eventStartTime = fetchResults[i].startTime
                event.eventEndDate = fetchResults[i].endDate
                event.eventEndTime = fetchResults[i].endTime
                
                event.eventLatitude = fetchResults[i].latitude as Double
                event.eventLongitude = fetchResults[i].longitude as Double
                
                event.venueID = fetchResults[i].venueID
                event.eventVenueName = fetchResults[i].venueName
                event.eventVenueAddress = fetchResults[i].venueAddress
                event.eventVenueCity = fetchResults[i].venueCity
                
                event.userID = fetchResults[i].userID
                
                event.primaryCategory = fetchResults[i].primaryCategory
                
                let fetchSubRequest = NSFetchRequest(entityName: "EventSubCategoryList")
                let predicate = NSPredicate(format: "eventID == %@", fetchResults[i].id)
                fetchSubRequest.predicate = predicate
                
                if let fetchSubResults = managedObjectContext!.executeFetchRequest(fetchSubRequest, error: nil) as? [EventSubCategoryDBModel]{
                    
                    for(var j = 0; j < fetchSubResults.count; ++j){
                        
                        event.subCategoryID?.append(fetchSubResults[j].subCategoryID as String)
                        event.subCategoryName?.append(fetchSubResults[j].subCategoryName as String)
                    }
                }
                
                returnedEvent.append(event)
                
            }
            
            return returnedEvent
        }
            
        else {
            return nil
        }
    }
    
    func fetchVenues() -> [VenueDBModel]?{
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "VenueList")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [VenueDBModel] {
            
            return fetchResults
            
        }
        else{
            return nil
        }
    }
    
    func fetchArtists() -> [ArtistDBModel]?{
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "ArtistList")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [ArtistDBModel] {
            
            return fetchResults
            
        }
        else{
            return nil
        }
    }
    
    func fetchOrganizations() -> [OrganizationDBModel]?{
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "OrganizationList")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [OrganizationDBModel] {
            
            return fetchResults
            
        }
        else{
            return nil
        }
    }
    
    func fetchUserInfo() -> [UserDBModel]?{
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "UserList")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserDBModel] {
            
            return fetchResults
            
        }
        else{
            return nil
        }
    }
}