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
                
                if !GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys.contains(tempEvent[i-1].primaryCategory) {
                    
                    let index = tempEvent.indexOf({$0.eventID == tempEvent[i-1].eventID})
                    tempEvent.removeAtIndex(index!)
                    
                } else { // goes into selected primary category, filters out events that dont match filter sub category
                    
                    if GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[tempEvent[i-1].primaryCategory]![0].count != 0 {
                        
                        for var j = tempEvent.count; j > 0; j-- {
                            
                        }

                        
                        print("HAHA", GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[tempEvent[i-1].primaryCategory])
                    }
                    
                }
            }
        }
        
        
        
        
        
        GlobalVariables.displayFilteredEvents = tempEvent
    }

}







