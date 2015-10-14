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
        //deleteAddictions()
    }
    
    // Deletes all entries of an object in the Core Data table
    // Does this one entry at a time rather than dropping entire tables
    
    func deleteEventCategories(){
        
        let fetchRequest = NSFetchRequest(entityName: "EventPrimaryCategories")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [EventPrimaryCategoriesDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        let fetchRequest2 = NSFetchRequest(entityName: "EventSubCategories")
        fetchRequest2.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest2, error: nil) as? [EventSubCategoriesDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        if !managedObjectContext!.save(&err) {
            println("deleteData - Error : \(err!.localizedDescription)")
            abort()
        } else {
            println("deleteData - Success - Event Categories")
        }
    }
    
    func deleteVenueCategories(){
        
        let fetchRequest = NSFetchRequest(entityName: "VenueCategories")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [VenueCategoriesDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        if !managedObjectContext!.save(&err) {
            println("deleteData - Error : \(err!.localizedDescription)")
            abort()
        } else {
            println("deleteData - Success - Venue Categories")
        }
    }
    
    func deleteArtistCategories(){
        
        let fetchRequest = NSFetchRequest(entityName: "ArtistCategories")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [ArtistCategoriesDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        if !managedObjectContext!.save(&err) {
            println("deleteData - Error : \(err!.localizedDescription)")
            abort()
        } else {
            println("deleteData - Success - Artist Categories")
        }
    }
    
    func deleteOrganizationCategories(){
        
        let fetchRequest = NSFetchRequest(entityName: "OrganizationCategories")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [OrganizationCategoriesDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        if !managedObjectContext!.save(&err) {
            println("deleteData - Error : \(err!.localizedDescription)")
            abort()
        } else {
            println("deleteData - Success - Organization Categories")
        }
    }
    
    func deleteEvents() {
        
        let fetchRequest = NSFetchRequest(entityName: "EventList")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [EventDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        if !managedObjectContext!.save(&err) {
            println("deleteData - Error : \(err!.localizedDescription)")
            abort()
        } else {
            println("deleteData - Success - Events")
        }
    }
    
    func deleteUserInfo() {
        
        let fetchRequest = NSFetchRequest(entityName: "UserList")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        if !managedObjectContext!.save(&err) {
            println("deleteData - Error : \(err!.localizedDescription)")
            abort()
        } else {
            println("deleteData - Success - Users")
        }
    }
    
    func deleteVenues() {
        
        let fetchRequest = NSFetchRequest(entityName: "VenueList")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [VenueDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        if !managedObjectContext!.save(&err) {
            println("deleteData - Error : \(err!.localizedDescription)")
            abort()
        } else {
            println("deleteData - Success - Venues")
        }
    }
    
    func deleteArtists() {
        
        let fetchRequest = NSFetchRequest(entityName: "ArtistList")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [ArtistDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        if !managedObjectContext!.save(&err) {
            println("deleteData - Error : \(err!.localizedDescription)")
            abort()
        } else {
            println("deleteData - Success - Artists")
        }
    }
    
    func deleteOrganizations() {
        
        let fetchRequest = NSFetchRequest(entityName: "OrganizationList")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [OrganizationDBModel] {
            
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
            }
            
        }
        
        var err: NSError?
        if !managedObjectContext!.save(&err) {
            println("deleteData - Error : \(err!.localizedDescription)")
            abort()
        } else {
            println("deleteData - Success - Organizations")
        }
    }
    
    func deleteAddictions() {
        let fetchRequestE = NSFetchRequest(entityName: "AddictionEvent")
        fetchRequestE.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequestE, error: nil) as? [AddictionEventDBModel] {
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
                println("number of event")
            }
        }
        
        let fetchRequestV = NSFetchRequest(entityName: "AddictionVenue")
        fetchRequestV.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequestV, error: nil) as? [AddictionVenueDBModel] {
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
                println("number of venue")
            }
        }
        
        let fetchRequestA = NSFetchRequest(entityName: "AddictionArtist")
        fetchRequestA.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequestA, error: nil) as? [AddictionArtistDBModel] {
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
                println("number of artist")
            }
        }
        
        let fetchRequestO = NSFetchRequest(entityName: "AddictionOrganization")
        fetchRequestO.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequestO, error: nil) as? [AddictionOrganizationDBModel] {
            for result in fetchResults {
                managedObjectContext!.deleteObject(result)
                println("number of organization")
            }
        }
        
        var err: NSError?
        if !managedObjectContext!.save(&err) {
            println("deleteData - Error : \(err!.localizedDescription)")
            abort()
        } else {
            println("deleteData - Success - Addictions")
        }

    }
    
    func deleteAddictionsEvent(deleteItem: String, deleteUser: String) {
        
        let fetchRequest = NSFetchRequest(entityName: "AddictionEvent")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [AddictionEventDBModel] {
            
            for result in fetchResults {
                
                if (result.eventID == deleteItem){
                    if(result.userID == deleteUser){
                        managedObjectContext!.deleteObject(result)
                    }
                }
            }
        }
        
        var err: NSError?
        if !managedObjectContext!.save(&err) {
            println("deleteData - Error : \(err!.localizedDescription)")
            abort()
        } else {
            println("deleteData - Success - AddictionsEvent")
        }

    }
    
    func deleteAddictionsVenue(deleteItem: String, deleteUser: String) {
        
        let fetchRequest = NSFetchRequest(entityName: "AddictionVenue")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [AddictionVenueDBModel] {
            
            for result in fetchResults {
                
                if (result.venueID == deleteItem){
                    if(result.userID == deleteUser){
                        managedObjectContext!.deleteObject(result)
                    }
                }
            }
        }
        
        var err: NSError?
        if !managedObjectContext!.save(&err) {
            println("deleteData - Error : \(err!.localizedDescription)")
            abort()
        } else {
            println("deleteData - Success - AddictionsVenue")
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
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [AddictionOrganizationDBModel] {
            
            for result in fetchResults {
                
                if (result.organizationID == deleteItem){
                    if(result.userID == deleteUser){
                        managedObjectContext!.deleteObject(result)
                    }
                }
            }
        }
        
        var err: NSError?
        if !managedObjectContext!.save(&err) {
            println("deleteData - Error : \(err!.localizedDescription)")
            abort()
        } else {
            println("deleteData - Success - AddictionsOrgainzation")
        }
        
    }
    

}
