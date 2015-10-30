//
//  Filtering.swift
//  Bruha
//
//  Created by Zhuoheng Wu on 2015-10-27.
//  Copyright © 2015 Bruha. All rights reserved.
//

import Foundation
import UIKit

class Filtering {
    
    var tempEvent: [Event] = GlobalVariables.displayedEvents
    var tempVenue: [Venue] = GlobalVariables.displayedVenues
    var tempOrganization: [Organization] = GlobalVariables.displayedOrganizations
    
    func filterEvents() {
        
        //date filter is not nil, filter out events don't have date
        if GlobalVariables.UserCustomFilters.dateFilter.count != 0 {
            
            for var i = tempEvent.count; i > 0; i-- {
                
                //when events don't match selected date in filter, remove events
                if !GlobalVariables.UserCustomFilters.dateFilter.contains(tempEvent[i-1].eventStartDate) {
                    let index = tempEvent.indexOf({$0.eventID == tempEvent[i-1].eventID})
                    tempEvent.removeAtIndex(index!)
                }
            }
        }
        
        //price filter is not nil, if event price > filter price, filter out events
        if GlobalVariables.UserCustomFilters.priceFilter != 0 {
            
            for var i = tempEvent.count; i > 0; i-- {
                
                if GlobalVariables.UserCustomFilters.priceFilter < Int(tempEvent[i-1].eventPrice!) {
                    let index = tempEvent.indexOf({$0.eventID == tempEvent[i-1].eventID})
                    tempEvent.removeAtIndex(index!)
                }
            }
        }
        
        //category filter is not nil,
        if GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.count != 0 {
            
            for var i = tempEvent.count; i > 0; i-- {
                
                //if event don't have primary category, filter out events
                if !GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys.contains(tempEvent[i-1].primaryCategory) {
                    let index = tempEvent.indexOf({$0.eventID == tempEvent[i-1].eventID})
                    tempEvent.removeAtIndex(index!)
                    
                } else { // goes into selected primary category, filters out events that don't match filter sub category
                    
                    var temp: [Event] = []
                    
                    for key in GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys {
                        //print(key)
                    
                        if GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[key]![0].count != 0 {
                        
                            //for var j = tempEvent[i-1].subCategoryID.count; j < 0; j-- {
                            for var j = 0; j < tempEvent[i-1].subCategoryID.count; j++ {
                                if GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[key]![0].contains(tempEvent[i-1].subCategoryID[j]) {
                                
                                    if !temp.contains({$0.eventID == tempEvent[i-1].eventID}) {
                                        temp.append(tempEvent[i-1])
                                    }
                                }
                            }
                            //print("HAHA", GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[key])
                        }
                    
                        else {
                            
                            if key == Array(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys)[0] {
                                if !temp.contains({$0.eventID == tempEvent[i-1].eventID}){
                                    temp.append(tempEvent[i-1])
                                    //print("name", Array(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys)[0])
                                }
                            }
                        }
                    }//end of for key
                    
                    if !temp.contains({$0.eventID == tempEvent[i-1].eventID}){
                        let index = tempEvent.indexOf({$0.eventID == tempEvent[i-1].eventID})
                        tempEvent.removeAtIndex(index!)
                    }
                    
                }
            }
        }
        
        if GlobalVariables.UserCustomFilters.dateFilter.count == 0 &&
            GlobalVariables.UserCustomFilters.priceFilter == 0 &&
            GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.count == 0 {
            
                tempEvent.removeAll()
                GlobalVariables.filterEventBool = false
                NSNotificationCenter.defaultCenter().postNotificationName("filter", object: nil)
                
        } else {
            GlobalVariables.filterEventBool = true
            NSNotificationCenter.defaultCenter().postNotificationName("filter", object: nil)
        }
        
        GlobalVariables.displayFilteredEvents = tempEvent
        
    }

    func filterVenues() {
        
        if GlobalVariables.UserCustomFilters.categoryFilter.venueCategories.count != 0 {
            
            for var i = tempVenue.count; i > 0; i-- {
                
                //when venues don't match selected category in filter, remove venues
                if !GlobalVariables.UserCustomFilters.categoryFilter.venueCategories.contains(tempVenue[i-1].primaryCategory) {
                    let index = tempVenue.indexOf({$0.venueID == tempVenue[i-1].venueID})
                    tempVenue.removeAtIndex(index!)
                }
            }
            GlobalVariables.filterVenueBool = true
            NSNotificationCenter.defaultCenter().postNotificationName("filter", object: nil)
            
        } else {
            tempVenue.removeAll()
            GlobalVariables.filterVenueBool = false
            NSNotificationCenter.defaultCenter().postNotificationName("filter", object: nil)
        }
        
        GlobalVariables.displayFilteredVenues = tempVenue
        
    }
    
    func filterOrganizations() {
        
        if GlobalVariables.UserCustomFilters.categoryFilter.organizationCategories.count != 0 {
            
            for var i = tempOrganization.count; i > 0; i-- {
                
                //when organizaitons don't match selected category in filter, remove organizations
                if !GlobalVariables.UserCustomFilters.categoryFilter.organizationCategories.contains(tempOrganization[i-1].primaryCategory) {
                    let index = tempOrganization.indexOf({$0.organizationID == tempOrganization[i-1].organizationID})
                    tempOrganization.removeAtIndex(index!)
                }
            }
            GlobalVariables.filterOrganizationBool = true
            NSNotificationCenter.defaultCenter().postNotificationName("filter", object: nil)
            
        } else {
            tempOrganization.removeAll()
            GlobalVariables.filterOrganizationBool = false
            NSNotificationCenter.defaultCenter().postNotificationName("filter", object: nil)
        }
        
        GlobalVariables.displayFilteredOrganizations = tempOrganization
        
    }
    
}







