//
//  CalendarFunc.swift
//  Calendar
//
//  Created by Hyewook Song on 2/14/16.
//  Copyright © 2016 It's too early. All rights reserved.
//

import Foundation
import EventKit

//set up date time
let today = NSDate()
let tmrw = today.dateByAddingTimeInterval(24 * 60 * 60)
let tdat = tmrw.dateByAddingTimeInterval(24 * 60 * 60)
let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
let newToday = cal.startOfDayForDate(today)
let newTmrw = cal.startOfDayForDate(tmrw)
let newTdat = cal.startOfDayForDate(tdat)

let eventStore = EKEventStore()

class calendar {
    //set up event object
    var objects = NSMutableArray()
    var events: [EKEvent] = []

    //request access to calendar
    //calls firstEvent() but it should be changed
    func accessCalendar() {
        
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: { (granted:Bool, error:NSError?) -> Void in
            
            //access granted
            if granted {
                print("Access granted!")
                
                self.allEvent()
            }
            //access denied
            else{
                print("Access denied!")
            }
        })

    }

    //loop through all calendars
    //get all events today
    //return array of string
    //string format: title, starttime, endtime, Optional(location), URL, Notes OR "No events found"
    //if URL, Notes does not exist -> nil
    func allEvent() -> Array<String> {
        
        //let calendars = eventStore.calendarsForEntityType(EKEntityType.Event)
        //for calendar in calendars as [EKCalendar]{
        //    print("Calendar = \(calendar.title)")
        //}
        let predicate = eventStore.predicateForEventsWithStartDate(newToday, endDate: newTmrw, calendars: nil)
        let events = eventStore.eventsMatchingPredicate(predicate) as[EKEvent]
        
        var eventString = String()
        var eventArray = [String]()
        
        if events.isEmpty == false {
            
            //all events
            for event in events{
     
                var startArr = String(event.startDate).componentsSeparatedByString(" ")
                var endArr = String(event.endDate).componentsSeparatedByString(" ")
                
                eventString = String(event.title) + "," + String(startArr[1]) + "," + String(endArr[1]) + "," + String(event.location) + "," + String(event.URL) + "," + String(event.notes)
                
                eventArray.append(eventString)
                
            }
        }
        else {
            eventString = "No events found"
            eventArray.append(eventString)
        }
        
        //print(eventArray)
        
        return eventArray
    }

    //loop through all calendars
    //get the first event of tomorrow: 1. Birthday calendar 2. Calendar event 3. Calendar Birthday
    //return string format: datetime in seconds,Optional(location) OR "No events found"
    func firstEvent() -> String {
        
        let predicate = eventStore.predicateForEventsWithStartDate(newTmrw, endDate: newTdat, calendars: nil)
        let events = eventStore.eventsMatchingPredicate(predicate) as[EKEvent]
        
        var firstString = String()
        
        if events.isEmpty == false {
            
            for event in events{
                
                //skip all day event
                if event.allDay == false {
                    
                    let startTime = event.startDate.timeIntervalSince1970
                    //var timeArr = String(event.startDate).componentsSeparatedByString(" ")
                        
                    firstString = String(startTime) + "," + String(event.location)
                    
                    break
                }
            }
        }
        else {
            
            firstString = "No events found"
        }

        print(firstString + "---------------------")
        
        return firstString
    }
}