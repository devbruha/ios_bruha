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
    
    func testing() {
        for event in GlobalVariables.displayedEvents {
            //print(event.eventName)
            if event.eventName == "Red Haven with Betty Supple "{
                print("Red \(event.subCategoryID.count)")
                //music, folk/country
            }
            
            if event.eventName == "Nick's Party"{
                print("Nick \(event.subCategoryID.count)")
                //party, LGBT
            }
            
        }
    }
    
    func filterCalendar() {
        
    }
    
    func filterPrice() {
        
    }
    
    func filterEvents() {
        
        //  All Events
        for event in GlobalVariables.displayedEvents {
            
            //  select primary category that is in filter
            if GlobalVariables.UserCustomFilters.categoryFilter.eventCategories.keys.contains("\(event.primaryCategory)") {
                
                
//                print(event.primaryCategory)
//                print(event.eventName)
//                print(GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[event.primaryCategory]![0])
                
                print("Filter \(event.subCategoryID.count)")
                
    
                
                //  sub category id
                for eventSubID in event.subCategoryID {
                    
                    if GlobalVariables.UserCustomFilters.categoryFilter.eventCategories[event.primaryCategory]![0].contains(eventSubID) {
                        
                        GlobalVariables.displayFilteredEvents.append(event)
                        
                    }
                }
                
            }
        }
    }
    
    
}










