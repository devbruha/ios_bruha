//
//  DeleteData.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-09.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData

class DeleteData {
    
    let managedObjectContext: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext?){
        
        self.managedObjectContext = context
    }
    
    func deleteAll() {
        
        deleteEventCategories()
        deleteVenueCategories()
        deleteArtistCategories()
        deleteOrganizationCategories()
        
        deleteEvents()
        deleteVenues()
        deleteArtists()
        deleteOrganizations()
        deleteAddictions()
        deleteUserEvents()
    }
    
    // Deletes all entries of an object in the Core Data table
    // Does this one entry at a time rather than dropping entire tables
    
    func deleteEventCategories(){
        
        let fetchRequest = NSFetchRequest(entityName: "EventPrimaryCategories")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [EventPrimaryCategoriesDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        let fetchRequest2 = NSFetchRequest(entityName: "EventSubCategories")
        fetchRequest2.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest2)) as? [EventSubCategoriesDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - Event Categories")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }
    }
    
    func deleteVenueCategories(){
        
        let fetchRequest = NSFetchRequest(entityName: "VenueCategories")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [VenueCategoriesDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - Venue Categories")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }
    }
    
    func deleteArtistCategories(){
        
        let fetchRequest = NSFetchRequest(entityName: "ArtistCategories")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [ArtistCategoriesDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - Artist Categories")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }
    }
    
    func deleteOrganizationCategories(){
        
        let fetchRequest = NSFetchRequest(entityName: "OrganizationCategories")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [OrganizationCategoriesDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - Organization Categories")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }
    }
    
    func deleteEvents() {
        
        let fetchRequest = NSFetchRequest(entityName: "EventList")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [EventDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - Events")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }
    }
    
    func deleteUserEvents() {
        
        let fetchRequest = NSFetchRequest(entityName: "UserEventList")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [UserEventDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - UserEvents")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }
    }
    
    func deleteUserInfo() {
        
        let fetchRequest = NSFetchRequest(entityName: "UserList")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [UserDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - Users")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }
    }
    
    func deleteVenues() {
        
        let fetchRequest = NSFetchRequest(entityName: "VenueList")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [VenueDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - Venues")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }
    }
    
    func deleteUserVenues() {
        
        let fetchRequest = NSFetchRequest(entityName: "UserVenueList")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [UserVenueDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - UserVenues")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }
    }
    
    func deleteArtists() {
        
        let fetchRequest = NSFetchRequest(entityName: "ArtistList")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [ArtistDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - Artists")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }
    }
    
    func deleteOrganizations() {
        
        let fetchRequest = NSFetchRequest(entityName: "OrganizationList")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [OrganizationDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - Organizations")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }
    }
    
    func deleteUserOrganizations() {
        
        let fetchRequest = NSFetchRequest(entityName: "UserOrganizationList")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [UserOrganizationDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - UserOrganizations")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }
    }
    
    func deleteAddictions() {
        let fetchRequestE = NSFetchRequest(entityName: "AddictionEvent")
        fetchRequestE.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequestE)) as? [AddictionEventDBModel] {
            
            print("number of event", fetchResults.count)
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
        }
        
        let fetchRequestV = NSFetchRequest(entityName: "AddictionVenue")
        fetchRequestV.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequestV)) as? [AddictionVenueDBModel] {
            
            print("number of venue", fetchResults.count)
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
        }
        
        let fetchRequestA = NSFetchRequest(entityName: "AddictionArtist")
        fetchRequestA.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequestA)) as? [AddictionArtistDBModel] {
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
                print("number of artist")
            }
        }
        
        let fetchRequestO = NSFetchRequest(entityName: "AddictionOrganization")
        fetchRequestO.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequestO)) as? [AddictionOrganizationDBModel] {
            
            print("number of organization", fetchResults.count)
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - Addictions")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }

    }
    
    func deleteAddictionsEvent(deleteItem: String, deleteUser: String) {
        
        let fetchRequest = NSFetchRequest(entityName: "AddictionEvent")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [AddictionEventDBModel] {
            
            for result in fetchResults {
                
                if (result.eventID == deleteItem){
                    if(result.userID == deleteUser){
                        managedObjectContext!.deleteObject(result)
                    }
                }
            }
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - AddictionsEvent")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }

    }
    
    func deleteAddictionsVenue(deleteItem: String, deleteUser: String) {
        
        let fetchRequest = NSFetchRequest(entityName: "AddictionVenue")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [AddictionVenueDBModel] {
            
            for result in fetchResults {
                
                if (result.venueID == deleteItem){
                    if(result.userID == deleteUser){
                        managedObjectContext!.deleteObject(result)
                    }
                }
            }
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - AddictionsVenue")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }
        
    }
    
//    func deleteAddictionsArtist(deleteItem: String, deleteUser: String) {
//        
//        let fetchRequest = NSFetchRequest(entityName: "AddictionArtist")
//        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
//        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [AddictionArtistDBModel] {
//            
//            for result in fetchResults {
//                
//                if (result.artistID == deleteItem){
//                    if(result.userID == deleteUser){
//                        managedObjectContext!.deleteObject(result)
//                    }
//                }
//            }
//        }
//        
//        var err: NSError?
//        if !managedObjectContext!.save(&err) {
//            println("deleteData - Error : \(err!.localizedDescription)")
//            abort()
//        } else {
//            println("deleteData - Success - AddictionsArtist")
//        }
//        
//    }
    
    func deleteAddictionsOrgainzation(deleteItem: String, deleteUser: String) {
        
        let fetchRequest = NSFetchRequest(entityName: "AddictionOrgainzation")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [AddictionOrganizationDBModel] {
            
            for result in fetchResults {
                
                if (result.organizationID == deleteItem){
                    if(result.userID == deleteUser){
                        managedObjectContext!.deleteObject(result)
                    }
                }
            }
        }
        
        var err: NSError?
        do {
            try managedObjectContext!.save()
            print("deleteData - Success - AddictionsOrgainzation")
        } catch let error as NSError {
            err = error
            print("deleteData - Error : \(err!.localizedDescription)")
            abort()
        }
        
    }
    
//    func deleteAddictedEvent(eventid: String) {
//        let eventService = EventService()
//        eventService.removeAddictedEvents(eventid) {
//            (let deleteInfo) in
//            
//            println(deleteInfo)
//        }
//    }
    
    func deleteAddictedVenue() {
        
    }
    
    func deleteAddictedOrganization() {
        
    }
    

}
