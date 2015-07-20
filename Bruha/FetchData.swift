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

    
    func fetchEvents() -> [EventDBModel]?{
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "EventList")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [EventDBModel] {
            
            return fetchResults
            
        }
        else{
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