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
    
    func fetchCategories() -> Categories {
        
        var returnedCategories = Categories(eventCategory: fetchEventCategories(), venueCategory: fetchVenueCategories(), artistCategory: fetchArtistCategories(), organizationCategory: fetchOrganizationCategories())
        
        return returnedCategories
    }

    func fetchEventCategories() -> Dictionary<String, [[String]]> {
     
        var returnedEventCategories = Dictionary<String, [[String]]>()
        
        let fetchRequest = NSFetchRequest(entityName: "EventPrimaryCategories")
        
        var descriptor: NSSortDescriptor = NSSortDescriptor(key: "categoryName", ascending: true)
        
        fetchRequest.sortDescriptors = [descriptor]
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [EventPrimaryCategoriesDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let fetchSubRequest = NSFetchRequest(entityName: "EventSubCategories")
                let predicate = NSPredicate(format: "primaryCategoryName == %@", fetchResults[i].categoryName)
                
                fetchSubRequest.predicate = predicate
                
                var subCatID: [String] = []
                var subCatName: [String] = []
                
                if let fetchSubResults = managedObjectContext!.executeFetchRequest(fetchSubRequest, error: nil) as? [EventSubCategoriesDBModel]{
                    
                    for(var j = 0; j < fetchSubResults.count; ++j){
                        
                        subCatID.append(fetchSubResults[j].subCategoryID)
                        subCatName.append(fetchSubResults[j].subCategoryName)
                    }
                    
                    returnedEventCategories[fetchResults[i].categoryName] = [subCatID,subCatName]
                }
            }
        }
    
        return returnedEventCategories
    }
    
    func fetchVenueCategories() -> [String] {
        
        var returnedVenueCategories = [String]()
        
        let fetchRequest = NSFetchRequest(entityName: "VenueCategories")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [VenueCategoriesDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                returnedVenueCategories.append(fetchResults[i].categoryName)
            }
        }
        
        return returnedVenueCategories
    }
    
    func fetchArtistCategories() -> [String] {
        
        var returnedArtistCategories = [String]()
        
        let fetchRequest = NSFetchRequest(entityName: "ArtistCategories")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [ArtistCategoriesDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                returnedArtistCategories.append(fetchResults[i].categoryName)
            }
        }
        
        return returnedArtistCategories
    }
    
    func fetchOrganizationCategories() -> [String] {
        
        var returnedOrganizationCategories = [String]()
        
        let fetchRequest = NSFetchRequest(entityName: "OrganizationCategories")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [OrganizationCategoriesDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                returnedOrganizationCategories.append(fetchResults[i].categoryName)
            }
        }
        
        return returnedOrganizationCategories
    }

    
    func fetchEvents() -> [Event]!{
        
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
    
    func fetchAddictions() -> [AddictionEvent]?{
        var returnedAddiction: [AddictionEvent] = [AddictionEvent]()
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "AddictionEvent")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [AddictionEventDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                var addiction = AddictionEvent(fetchResults: fetchResults[i])
                
                returnedAddiction.append(addiction)
            }
            
            return returnedAddiction
            
        }
        else{
            return nil
        }

    }
}