//
//  SaveData.swift
//  BruhaMobile
//
//  Created by Ryan O'Neill on 2015-07-09.
//  Copyright (c) 2015 Bruha. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// Each function in this class stores a certain object into the local database (Core Data)

class SaveData {
    
    let managedObjectContext: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext?){
        
        // Retrieves passed in context
        
        self.managedObjectContext = context
    }
    
    func saveCategories(categoryDictionary: Categories){
        
        //GlobalVariables.categories = categoryDictionary
        
        saveEventCategories(categoryDictionary.eventCategories)
        saveVenueCategories(categoryDictionary.venueCategories)
        saveArtistCategories(categoryDictionary.artistCategories)
        saveOrganizationCategories(categoryDictionary.organizationCategories)
    }
    
    func saveEventCategories(eventCategories: Dictionary<String, [[String]]>){
        
        let en = NSEntityDescription.entityForName("EventPrimaryCategories", inManagedObjectContext: managedObjectContext!)
        let en2 = NSEntityDescription.entityForName("EventSubCategories", inManagedObjectContext: managedObjectContext!)
        
        for key in eventCategories.keys{
            
            let newItem = EventPrimaryCategoriesDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.categoryName = key
            
            do {
                try managedObjectContext!.save()
            } catch _ {
            }
            
            for( var i = 0; i < eventCategories[key]![0].count; ++i ){
                
                let newItem2 = EventSubCategoriesDBModel(entity:en2!, insertIntoManagedObjectContext: managedObjectContext!)
                
                newItem2.primaryCategoryName = key
                newItem2.subCategoryID = eventCategories[key]![0][i]
                newItem2.subCategoryName = eventCategories[key]![1][i]
                
                do {
                    try managedObjectContext!.save()
                } catch _ {
                }
            }
        }
        
        print("Event Categories Saved")
    }
    
    func saveVenueCategories(venueCategories: [String]){
        
        let en = NSEntityDescription.entityForName("VenueCategories", inManagedObjectContext: managedObjectContext!)
        
        for category in venueCategories{
            
            let newItem = VenueCategoriesDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.categoryName = category
            
            do {
                try managedObjectContext!.save()
            } catch _ {
            }
            
        }
        
        print("Venue Categories Saved")
    }
    
    func saveArtistCategories(artistCategories: [String]){
        
        let en = NSEntityDescription.entityForName("ArtistCategories", inManagedObjectContext: managedObjectContext!)
        
        for category in artistCategories{
            
            let newItem = ArtistCategoriesDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.categoryName = category
            
            do {
                try managedObjectContext!.save()
            } catch _ {
            }
            
        }
        
        print("Artist Categories Saved")
    }
    
    func saveOrganizationCategories(organizationCategories: [String]){
        
        let en = NSEntityDescription.entityForName("OrganizationCategories", inManagedObjectContext: managedObjectContext!)
        
        for category in organizationCategories{
            
            let newItem = OrganizationCategoriesDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.categoryName = category
            
            do {
                try managedObjectContext!.save()
            } catch _ {
            }
            
        }
        
        print("Organization Categories Saved")
    }
    
    func saveEvents(EventList: [Event]){
                
        let en = NSEntityDescription.entityForName("EventList", inManagedObjectContext: managedObjectContext!)
        let en2 = NSEntityDescription.entityForName("EventSubCategoryList", inManagedObjectContext: managedObjectContext!)
        
        for event in EventList{
            
            // Creating template object that'll be pushed into the local database
            
            let newItem = EventDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.id = event.eventID
            newItem.name = event.eventName
            newItem.price = event.eventPrice!
            newItem.eventDescription = event.eventDescription
            newItem.primaryCategory = event.primaryCategory
            
            for(var i = 0; i < event.subCategoryName.count; ++i){
                
                let newSubItem = EventSubCategoryDBModel(entity:en2!, insertIntoManagedObjectContext: managedObjectContext!)
                
                newSubItem.eventID = event.eventID
                newSubItem.subCategoryID = event.subCategoryID[i]
                newSubItem.subCategoryName = event.subCategoryName[i]
                
                do {
                    try managedObjectContext!.save()
                } catch _ {
                }
            }
            
            newItem.startTime = event.eventStartTime
            newItem.endTime = event.eventEndTime
            newItem.startDate = event.eventStartDate
            newItem.endDate = event.eventEndDate
            newItem.latitude = event.eventLatitude
            newItem.longitude = event.eventLongitude
            
            newItem.venueID = event.venueID
            newItem.venueName = event.eventVenueName
            newItem.venueCity = event.eventVenueCity
            newItem.venueAddress = event.eventVenueAddress
            
            newItem.userID = event.userID
            
            newItem.posterUrl = event.posterUrl
            
            do {
                try managedObjectContext!.save()
            } catch _ {
            }
        }
        
        print("Event Save")
    }
    
    func saveUserEvents(EventList: [Event]){
        
        let en = NSEntityDescription.entityForName("UserEventList", inManagedObjectContext: managedObjectContext!)
        let en2 = NSEntityDescription.entityForName("UserEventSubCategoryList", inManagedObjectContext: managedObjectContext!)
        
        for event in EventList{
            
            // Creating template object that'll be pushed into the local database
            
            let newItem = UserEventDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.id = event.eventID
            newItem.name = event.eventName
            newItem.price = event.eventPrice!
            newItem.eventDescription = event.eventDescription
            newItem.primaryCategory = event.primaryCategory
            
            for(var i = 0; i < event.subCategoryName.count; ++i){
                
                let newSubItem = UserEventSubCategoryDBModel(entity:en2!, insertIntoManagedObjectContext: managedObjectContext!)
                
                newSubItem.eventID = event.eventID
                newSubItem.subCategoryID = event.subCategoryID[i]
                newSubItem.subCategoryName = event.subCategoryName[i]
                
                do {
                    try managedObjectContext!.save()
                } catch _ {
                }
            }
            
            newItem.startTime = event.eventStartTime
            newItem.endTime = event.eventEndTime
            newItem.startDate = event.eventStartDate
            newItem.endDate = event.eventEndDate
            newItem.latitude = event.eventLatitude
            newItem.longitude = event.eventLongitude
            
            newItem.venueID = event.venueID
            newItem.venueName = event.eventVenueName
            newItem.venueCity = event.eventVenueCity
            newItem.venueAddress = event.eventVenueAddress
            
            
            newItem.posterUrl = event.posterUrl
            
            do {
                try managedObjectContext!.save()
            } catch _ {
            }
        }
        
        print("User Event Save")
    }

    
    func saveVenues(VenueList: [Venue]){
        
        let en = NSEntityDescription.entityForName("VenueList", inManagedObjectContext: managedObjectContext!)
        
        for venue in VenueList{
            
            let newItem = VenueDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.id = venue.venueID
            newItem.name = venue.venueName
            newItem.venueDescription = venue.venueDescription
            newItem.primaryCategory = venue.primaryCategory
            newItem.address = venue.venueAddress
            newItem.latitude = venue.venueLatitude
            newItem.longitude = venue.venueLongitude
            newItem.posterUrl = venue.posterUrl
            
            do {
                try managedObjectContext!.save()
            } catch _ {
            }
        }
        
        print("Venue Save")
    }
    
    func saveUserVenues(VenueList: [Venue]){
        
        let en = NSEntityDescription.entityForName("UserVenueList", inManagedObjectContext: managedObjectContext!)
        
        for venue in VenueList{
            
            let newItem = UserVenueDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.id = venue.venueID
            newItem.name = venue.venueName
            newItem.venueDescription = venue.venueDescription
            newItem.primaryCategory = venue.primaryCategory
            newItem.address = venue.venueAddress
            newItem.latitude = venue.venueLatitude
            newItem.longitude = venue.venueLongitude
            newItem.posterUrl = venue.posterUrl
            
            do {
                try managedObjectContext!.save()
            } catch _ {
            }
        }
        
        print("User Venue Save")
    }
    
    func saveArtists(ArtistList: [Artist]){
        
        let en = NSEntityDescription.entityForName("ArtistList", inManagedObjectContext: managedObjectContext!)
        
        for artist in ArtistList{
            
            let newItem = ArtistDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.name = artist.artistName
            newItem.artistDescription = artist.artistDescription
            newItem.primaryCategory = artist.primaryCategory
            newItem.id = artist.artistID
            newItem.posterUrl = artist.posterUrl
            
            do {
                try managedObjectContext!.save()
            } catch _ {
            }
        }
        
        print("Artist Save")
    }
    
    func saveOrganizations(OrganizationList: [Organization]){
        
        let en = NSEntityDescription.entityForName("OrganizationList", inManagedObjectContext: managedObjectContext!)
        
        for organization in OrganizationList{
            
            let newItem = OrganizationDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.id = organization.organizationID
            newItem.name = organization.organizationName
            newItem.orgDescription = organization.organizationDescription
            newItem.primaryCategory = organization.primaryCategory
            newItem.address = organization.organizationAddress
            newItem.latitude = organization.organizationLatitude
            newItem.longitude = organization.organizationLongitude
            newItem.posterUrl = organization.posterUrl
            
            do {
                try managedObjectContext!.save()
            } catch _ {
            }
        }
        
        print("Organization Save")
    }
    
    func saveUserOrganizations(OrganizationList: [Organization]){
        
        let en = NSEntityDescription.entityForName("UserOrganizationList", inManagedObjectContext: managedObjectContext!)
        
        for organization in OrganizationList{
            
            let newItem = UserOrganizationDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.id = organization.organizationID
            newItem.name = organization.organizationName
            newItem.orgDescription = organization.organizationDescription
            newItem.primaryCategory = organization.primaryCategory
            newItem.address = organization.organizationAddress
            newItem.latitude = organization.organizationLatitude
            newItem.longitude = organization.organizationLongitude
            newItem.posterUrl = organization.posterUrl
            
            do {
                try managedObjectContext!.save()
            } catch _ {
            }
        }
        
        print("User Organization Save")
    }
    
    func saveUser(user: User){
        
        let en = NSEntityDescription.entityForName("UserList", inManagedObjectContext: managedObjectContext!)
        
        let newItem = UserDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
        
        newItem.userName = user.userName
        newItem.firstName = user.userFirstName!
        
        if let cityString = user.userCity {
            newItem.city = cityString
        } else {
            newItem.city = ""
        }
        
        newItem.birthdate = user.userBirthdate!
        newItem.gender = user.userGender!
        newItem.email = user.userEmail!
        
        do {
            try managedObjectContext!.save()
        } catch _ {
        }
        
        
        print("User Save")
    }
    
    func saveAddictionEvent(addiction: AddictionEvent) {
        
        let en = NSEntityDescription.entityForName("AddictionEvent", inManagedObjectContext: managedObjectContext!)
            
            let newItem = AddictionEventDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.eventID = addiction.eventID
            newItem.userID = addiction.userID
            
            do {
                try managedObjectContext!.save()
            } catch _ {
            }
            
        
        print("Addiction Event Save")
        
    }
    
    func saveAddictionVenue(addiction: AddictionVenue) {
        
        let en = NSEntityDescription.entityForName("AddictionVenue", inManagedObjectContext: managedObjectContext!)
        
        let newItem = AddictionVenueDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
        
        newItem.venueID = addiction.venueID
        newItem.userID = addiction.userID
        
        do {
            try managedObjectContext!.save()
        } catch _ {
        }
        
        
        print("Addiction Venue Save")
        
    }
    
//    func saveAddictionArtist(addiction: AddictionArtist) {
//        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let en = NSEntityDescription.entityForName("AddictionArtist", inManagedObjectContext: managedObjectContext!)
//        
//        var newItem = AddictionArtistDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
//        
//        newItem.artistID = addiction.artistID
//        newItem.userID = addiction.userID
//        
//        managedObjectContext!.save(nil)
//        
//        
//        println("Addiction Artist Save")
//        
//    }
    
    func saveAddictionOrganization(addiction: AddictionOrganization) {
        
        let en = NSEntityDescription.entityForName("AddictionOrganization", inManagedObjectContext: managedObjectContext!)
        
        let newItem = AddictionOrganizationDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
        
        newItem.organizationID = addiction.organizationID
        newItem.userID = addiction.userID
        
        do {
            try managedObjectContext!.save()
        } catch _ {
        }
        
        
        print("Addiction Organization Save")
        
    }
    
    func savePosterImages(image: Image) {
        
        let en = NSEntityDescription.entityForName("ImageList", inManagedObjectContext: managedObjectContext!)
        
        let newItem = ImageDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
        
        newItem.id = image.ID
        newItem.imageData = image.Image
        
        do {
            try managedObjectContext!.save()
        } catch _ {
        }
        
        
        print("Poster Image Save")
        
    }
    
}


