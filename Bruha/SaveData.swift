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

class SaveData {
    
    let managedObjectContext: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext?){
        
        self.managedObjectContext = context
    }
    
    func saveEvents(EventList: [Event]){
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let en = NSEntityDescription.entityForName("EventList", inManagedObjectContext: managedObjectContext!)
        
        for event in EventList{
            
            var newItem = EventDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.id = event.eventID!
            newItem.name = event.eventName!
            newItem.price = event.eventPrice!
            newItem.eventDescription = event.eventDescription!
            newItem.startTime = event.eventStartTime!
            newItem.endTime = event.eventEndTime!
            newItem.startDate = event.eventStartDate!
            newItem.endDate = event.eventEndDate!
            
            newItem.locationID = event.locationID!
            newItem.latitude = event.eventLatitude!
            newItem.longitude = event.eventLongitude!
            
            newItem.venueID = event.venueID!
            newItem.venueName = event.eventVenueName!
            newItem.venueCity = event.eventVenueCity!
            newItem.venueAddress = event.eventVenueAddress!
            
            managedObjectContext!.save(nil)
        }
        
        println("Event Save")
        
        //println(FetchData(context: managedObjectContext).fetchEvents()?.count)
    }
    
    func saveVenues(VenueList: [Venue]){
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let en = NSEntityDescription.entityForName("VenueList", inManagedObjectContext: managedObjectContext!)
        
        for venue in VenueList{
            
            var newItem = VenueDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.name = venue.venueName!
            newItem.venueDescription = venue.venueDescription!
            newItem.location = venue.venueLocation!
            newItem.latitude = venue.venueLatitude!
            newItem.longitude = venue.venueLongitude!
            
            managedObjectContext!.save(nil)
        }
        
        println("Venue Save")
        
        //println(FetchData(context: managedObjectContext).fetchVenues()?.count)
        
    }
    
    func saveArtists(ArtistList: [Artist]){
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let en = NSEntityDescription.entityForName("ArtistList", inManagedObjectContext: managedObjectContext!)
        
        for artist in ArtistList{
            
            var newItem = ArtistDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.name = artist.artistName!
            newItem.artistDescription = artist.artistDescription!
            newItem.id = artist.artistID!
            
            managedObjectContext!.save(nil)
        }
        
        println("Artist Save")
        
        //println(FetchData(context: managedObjectContext).fetchArtists()?.count)
        
    }
    
    func saveOrganizations(OrganizationList: [Organization]){
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let en = NSEntityDescription.entityForName("OrganizationList", inManagedObjectContext: managedObjectContext!)
        
        for organization in OrganizationList{
            
            var newItem = OrganizationDBModel(entity:en!, insertIntoManagedObjectContext: managedObjectContext!)
            
            newItem.id = organization.organizationID!
            newItem.name = organization.organizationName!
            newItem.orgDescription = organization.organizationDescription!
            newItem.locID = organization.locationID!
            newItem.location = organization.organizationLocation!
            newItem.latitude = organization.organizationLatitude!
            newItem.longitude = organization.organizationLongitude!
            
            managedObjectContext!.save(nil)
        }
        
        println("Organization Save")
        
        //println(FetchData(context: managedObjectContext).fetchOrganizations()?.count)
        
    }
}