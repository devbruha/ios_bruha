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
        
        let returnedCategories = Categories(eventCategory: fetchEventCategories(), venueCategory: fetchVenueCategories(), artistCategory: fetchArtistCategories(), organizationCategory: fetchOrganizationCategories())
        
        GlobalVariables.categories = returnedCategories
        
        return returnedCategories
    }

    func fetchEventCategories() -> Dictionary<String, [[String]]> {
     
        var returnedEventCategories = Dictionary<String, [[String]]>()
        
        let fetchRequest = NSFetchRequest(entityName: "EventPrimaryCategories")
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "categoryName", ascending: true)
        
        fetchRequest.sortDescriptors = [descriptor]
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [EventPrimaryCategoriesDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let fetchSubRequest = NSFetchRequest(entityName: "EventSubCategories")
                let predicate = NSPredicate(format: "primaryCategoryName == %@", fetchResults[i].categoryName)
                
                fetchSubRequest.predicate = predicate
                
                var subCatID: [String] = []
                var subCatName: [String] = []
                
                if let fetchSubResults = (try? managedObjectContext!.executeFetchRequest(fetchSubRequest)) as? [EventSubCategoriesDBModel]{
                    
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
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [VenueCategoriesDBModel] {
            
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
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [ArtistCategoriesDBModel] {
            
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
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [OrganizationCategoriesDBModel] {
            
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
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [EventDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let fetchSubRequest = NSFetchRequest(entityName: "EventSubCategoryList")
                let predicate = NSPredicate(format: "eventID == %@", fetchResults[i].id)
                fetchSubRequest.predicate = predicate
                
                if let fetchSubResults = (try? managedObjectContext!.executeFetchRequest(fetchSubRequest)) as? [EventSubCategoryDBModel]{
                    
        
                    let event = Event(fetchResults: fetchResults[i], fetchSubResults: fetchSubResults)
                    returnedEvent.append(event)
                }
                
            }
            
            return returnedEvent
        }
            
        else {
            return nil
        }
    }
    
    func fetchUserEvents() -> [Event]?{
        
        var returnedEvent: [Event] = [Event]()
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "UserEventList")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [UserEventDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let fetchSubRequest = NSFetchRequest(entityName: "UserEventSubCategoryList")
                let predicate = NSPredicate(format: "eventID == %@", fetchResults[i].id)
                fetchSubRequest.predicate = predicate
                
                if let fetchSubResults = (try? managedObjectContext!.executeFetchRequest(fetchSubRequest)) as? [UserEventSubCategoryDBModel]{
                    
                    
                    let event = Event(fetchUserResults: fetchResults[i], fetchUserSubResults: fetchSubResults)
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
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [VenueDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let venue = Venue(fetchResults: fetchResults[i])
                
                returnedVenue.append(venue)
            }
            
            return returnedVenue
        }
        else{
            
            return nil
        }
    }
    
    func fetchUserVenues() -> [Venue]?{
        
        var returnedVenue: [Venue] = [Venue]()
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "UserVenueList")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [UserVenueDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let venue = Venue(fetchUserResults: fetchResults[i])
                
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
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [ArtistDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let artist = Artist(fetchResults: fetchResults[i])
                
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
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [OrganizationDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let organization = Organization(fetchResults: fetchResults[i])
                
                returnedOrganization.append(organization)
            }
            
            return returnedOrganization
            
        }
        else{
            return nil
        }
    }
    
    func fetchUserOrganizations() -> [Organization]?{
        
        var returnedOrganization: [Organization] = [Organization]()
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "UserOrganizationList")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [UserOrganizationDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let organization = Organization(fetchUserResults: fetchResults[i])
                
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
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [UserDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let user = User(fetchResults: fetchResults[i])
                GlobalVariables.username = user.userName
                
                returnedUser.append(user)
            }
            
            return returnedUser
            
        }
        else{
            return nil
        }
    }
    
    func fetchAddictionsEvent() -> [AddictionEvent]?{
        var returnedAddiction: [AddictionEvent] = [AddictionEvent]()
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "AddictionEvent")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [AddictionEventDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let addiction = AddictionEvent(fetchResults: fetchResults[i])
                
                returnedAddiction.append(addiction)
            }
            
            return returnedAddiction
            
        }
        else{
            return nil
        }

    }
    
    func fetchAddictionsVenue() -> [AddictionVenue]?{
        var returnedAddiction: [AddictionVenue] = [AddictionVenue]()
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "AddictionVenue")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [AddictionVenueDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let addiction = AddictionVenue(fetchResults: fetchResults[i])
                
                returnedAddiction.append(addiction)
            }
            
            return returnedAddiction
            
        }
        else{
            return nil
        }
        
    }
    
    func fetchAddictionsOrganization() -> [AddictionOrganization]?{
        var returnedAddiction: [AddictionOrganization] = [AddictionOrganization]()
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "AddictionOrganization")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [AddictionOrganizationDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let addiction = AddictionOrganization(fetchResults: fetchResults[i])
                
                returnedAddiction.append(addiction)
            }
            
            return returnedAddiction
            
        }
        else{
            return nil
        }
        
    }
    
    func fetchPosterImages() -> [Image]?{
        var returnedImage: [Image] = [Image]()
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "ImageList")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [ImageDBModel] {
            
            for(var i = 0; i < fetchResults.count; ++i){
                
                let addiction = Image(fetchResults: fetchResults[i])
                
                returnedImage.append(addiction)
            }
            
            return returnedImage
            
        }
        else{
            return nil
        }
        
    }
    
    
}