//
//  CalendarViewController.swift
//  Bruha
//
//  Created by lye on 15/12/25.
//  Copyright © 2015年 Bruha. All rights reserved.
//

import UIKit
import Foundation

class CalendarViewController: UIViewController, JTCalendarDelegate{

    @IBOutlet weak var calendarMenu: JTCalendarMenuView!
    @IBOutlet weak var calendarContentView: JTHorizontalCalendarView!
    
    let calendarManager: JTCalendarManager = JTCalendarManager()
    let datesSelected = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calendarManager.delegate = self
        
        calendarManager.menuView = calendarMenu
        calendarManager.contentView = calendarContentView
        calendarManager.setDate(NSDate())
    }
    
    
    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        
        let newDayView = dayView as! JTCalendarDayView
        
        
        newDayView.hidden = false
        newDayView.backgroundColor = UIColor.blackColor()
        newDayView.textLabel.textColor = UIColor.whiteColor()
        
        newDayView.layer.borderColor = UIColor.grayColor().CGColor
        newDayView.layer.borderWidth = 0.5
        
        
        if(newDayView.isFromAnotherMonth){
            newDayView.alpha = 0.5
        }
        else if(datesSelected.containsObject(newDayView.date)){
            newDayView.backgroundColor = UIColor.cyanColor()
        }
    }
    
    func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        
        let newDayView = dayView as! JTCalendarDayView
        
        if(datesSelected.containsObject(newDayView.date)){
            
            datesSelected.removeObject(newDayView.date)
            newDayView.backgroundColor = UIColor.blackColor()
        }
        else{
            datesSelected.addObject(newDayView.date)
            newDayView.backgroundColor = UIColor.cyanColor()
        }
    }
    
    func calendar(calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: NSDate!) {
        
        let newMenuItemView = menuItemView as! UILabel
        
        let calendar = NSCalendar.currentCalendar()
        let component = calendar.component(NSCalendarUnit.Year, fromDate: date)
        let month = calendar.component(NSCalendarUnit.Month, fromDate: date)
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        let months = dateFormatter.monthSymbols
        let monthSymbol = months[month-1]
        
        //newMenuItemView.text = component as? String
        newMenuItemView.text = monthSymbol + " " + String(component)
        //newMenuItemView.text = monthSymbol
        //newMenuItemView.backgroundColor = UIColor.cyanColor()
        //newMenuItemView.textColor = UIColor.blackColor()
        //newMenuItemView.scrollView
        
    }
    //
    //    func calendarBuildWeekDayView(calendar: JTCalendarManager!) -> UIView! {
    //
    //
    //    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

