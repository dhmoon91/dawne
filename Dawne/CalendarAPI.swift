//
//  CalendarAPI.swift
//  Dawne
//
//  Created by Hyewook Song on 2/20/16.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import Foundation
import EventKit

class calendar {
    
    //set up date time
    let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    var today: NSDate {
        return  NSDate()
    }
    var tmrw: NSDate {
        return  today.dateByAddingTimeInterval(24 * 60 * 60)
    }
    var tdat: NSDate {
        return  tmrw.dateByAddingTimeInterval(24 * 60 * 60)
    }
    var newToday: NSDate {
        return  cal.startOfDayForDate(today)
    }
    var newTmrw: NSDate {
        return  cal.startOfDayForDate(tmrw)
    }
    var newTdat: NSDate {
        return  cal.startOfDayForDate(tdat)
    }
    
    
    //set up event object
    var objects = NSMutableArray()
    var events: [EKEvent] = []
    var location: String?
    var location2: String?
    var startTime: Int?
    var firstName = "First Event of the Day"
    
    var firstString = "No events found"
    var secondString = "No events found"
    
    let eventStore = EKEventStore()
    
    
    init() {
        
        accessCalendar()
    }
    
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
    //string format: title/starttime/endtime/location/Optional(URL)/Optional(Notes) OR "No events found"
    //if URL, Notes does not exist -> nil
    func allEvent() -> Array<Event> {
        
        //let calendars = eventStore.calendarsForEntityType(EKEntityType.Event)
        //for calendar in calendars as [EKCalendar]{
        //    print("Calendar = \(calendar.title)")
        //}
        let predicate = eventStore.predicateForEventsWithStartDate(newToday, endDate: newTmrw, calendars: nil)
        let events = eventStore.eventsMatchingPredicate(predicate) as[EKEvent]
        
        var eventString = String()
        var eventArray = [Event]()
        
        if events.isEmpty == false {
            
            //all events
            for event in events{
                let start = event.startDate
                let end = event.endDate
                
                let dateFormatter = NSDateFormatter()
                
                dateFormatter.dateFormat = "hh:mm a"
                
                let title = String(event.title)
                let location = String(event.location!)
                let sTime = dateFormatter.stringFromDate(start)
                let eTime = dateFormatter.stringFromDate(end)
                
                let newEvent = Event(title: title, location: location, startTime: sTime, endTime: eTime)
                
                eventString = String(event.title) + "/" + sTime + "/" + eTime + "/" + String(event.location!) + "/" + String(event.URL) + "/" + String(event.notes)
                //print(eventString)
                
                eventArray.append(newEvent)
                
            }
        }
        
        //print(eventArray)
        
        return eventArray
    }
    
    func greater(lhs: NSDate, rhs: NSDate) -> Bool {
        return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
    }
    
    func firstEventToday() -> NSDate {
        
        let predicate = eventStore.predicateForEventsWithStartDate(newToday, endDate: newTmrw, calendars: nil)
        let events = eventStore.eventsMatchingPredicate(predicate) as[EKEvent]
        var returnDate = NSDate.distantPast()
        
        if events.isEmpty == false {
            
            for event in events{
                
                //skip all day event
                if event.allDay == false {
                    firstName = event.title
                    let location = event.location
                    let startTime = Int(event.startDate.timeIntervalSince1970)
                    let stTime = String(startTime)
                    print(event.title)
                    secondString = stTime + "/" + location! + "/" + String(event.startDate.timeIntervalSince1970)
                    returnDate = event.startDate
                    break
                }
            }
        }
        else {
            firstName = "First Event of the Day"
            secondString = "No events found"
        }
        
        return returnDate
    }
    
    //loop through all calendars
    //get the first event of tomorrow: 1. Birthday calendar 2. Calendar event 3. Calendar Birthday
    //return string format: datetime in seconds as Int as String/location/seconds as Double as String OR "No events found"
    func firstEvent() -> String {
        
        let todayEvent = firstEventToday()
        
        if greater(todayEvent, rhs: today)  {
            
            return secondString
            
        }
        else {
            
            let predicate = eventStore.predicateForEventsWithStartDate(newTmrw, endDate: newTdat, calendars: nil)
            let events = eventStore.eventsMatchingPredicate(predicate) as[EKEvent]
            
            if events.isEmpty == false {
                
                for event in events{
                    
                    //skip all day event
                    if event.allDay == false {
                        firstName = event.title
                        let location = event.location
                        let startTime = Int(event.startDate.timeIntervalSince1970)
                        let stTime = String(startTime)
                        print(event.title)
                        firstString = stTime + "/" + location! + "/" + String(event.startDate.timeIntervalSince1970)
                        
                        break
                    }
                }
            }
            else {
                firstName = "First Event of the Day"
                firstString = "No events found"
            }
        
        }
        return firstString
    }
 
    
    
    // add courses to the calendar
    func addCourseCal(newCourses: [ClassSchedule]) {
    
        var startDay = NSDate()
        var endDay = NSDate()
        var newDay: NSDate?
        var newDay2: NSDate?
        var lastDay: NSDate?
        //var examDay: NSDate?
        let curCal = NSCalendar.currentCalendar()
        let components = curCal.components([.Year, .Weekday], fromDate: NSDate())
        var term: String

        
        for course in 0..<newCourses.count {
        
            var daysUntil = 10
            var parse: String
            var days: [EKRecurrenceDayOfWeek] = []
            let event = EKEvent(eventStore: eventStore)
            
            let secArr = newCourses[course].section!.componentsSeparatedByString(" ")
            if secArr[0] != "TST" {
            
                for var indexTemp = 0; indexTemp < newCourses[course].parsedDays!.count ; indexTemp++
                {
                    parse = newCourses[course].parsedDays![indexTemp]
                    
                    switch parse {
                        
                    case "M":
                        days.append(EKRecurrenceDayOfWeek(.Monday))
                        let daysUntilMon = (2 + 7 - components.weekday) % 7
                        if daysUntil > daysUntilMon {
                            daysUntil = daysUntilMon
                        }
                    
                    case "T":
                        days.append(EKRecurrenceDayOfWeek(.Tuesday))
                        let daysUntilTue = (3 + 7 - components.weekday) % 7
                        if daysUntil > daysUntilTue {
                            daysUntil = daysUntilTue
                        }
                        
                    case "W":
                        days.append(EKRecurrenceDayOfWeek(.Wednesday))
                        let daysUntilWed = (4 + 7 - components.weekday) % 7
                        if daysUntil > daysUntilWed {
                            daysUntil = daysUntilWed
                        }
                        
                    case "Th":
                        days.append(EKRecurrenceDayOfWeek(.Thursday))
                        let daysUntilThu = (5 + 7 - components.weekday) % 7
                        if daysUntil > daysUntilThu {
                            daysUntil = daysUntilThu
                        }
                        
                    case "F":
                        days.append(EKRecurrenceDayOfWeek(.Friday))
                        let daysUntilFri = (6 + 7 - components.weekday) % 7
                        if daysUntil > daysUntilFri {
                            daysUntil = daysUntilFri
                        }
                        
                    default:
                        print("PARSE ERROR -- weekday")
                    }
                }
                    
                newDay = curCal.dateByAddingUnit(NSCalendarUnit.Day, value: daysUntil, toDate: NSDate(), options: [])
                
                var tempArr = newCourses[course].start!.componentsSeparatedByString(":")
                let components2 = curCal.components([.Day, .Month, .Year], fromDate: newDay!)
                components2.hour = Int(tempArr[0])!
                components2.minute = Int(tempArr[1])!

                
                newDay2 = curCal.dateFromComponents(components2)
                
                tempArr = newCourses[course].end!.componentsSeparatedByString(":")
                components2.hour = Int(tempArr[0])!
                components2.minute = Int(tempArr[1])!
                
                
                startDay = newDay2!
                endDay = curCal.dateFromComponents(components2)!
                
                //does not include the last day
                term = newCourses[course].term!
                switch term {
                    
                    case "Winter":
                        components.month = 4
                        components.weekday = 3
                        components.weekdayOrdinal = 1
                        lastDay = curCal.dateFromComponents(components)
                    
                    case "Spring":
                        components.month = 7
                        components.weekday = 3
                        components.weekdayOrdinal = -1
                        lastDay = curCal.dateFromComponents(components)
                    
                    case "Fall":
                        components.month = 12
                        components.weekday = 3
                        components.weekdayOrdinal = 1
                        lastDay = curCal.dateFromComponents(components)
                    
                    default:
                        
                        print("TERM ERROR")
                    
                }
                
                
                let rule = EKRecurrenceRule(recurrenceWithFrequency: .Weekly,
                    interval: 1,
                    daysOfTheWeek: days,
                    daysOfTheMonth: nil,
                    monthsOfTheYear: nil,
                    weeksOfTheYear: nil,
                    daysOfTheYear: nil,
                    setPositions: nil,
                    end: EKRecurrenceEnd.init(endDate: lastDay!))
                
                event.calendar = eventStore.defaultCalendarForNewEvents
                event.title = newCourses[course].course! + newCourses[course].code! + " " + newCourses[course].section!
                event.startDate = startDay
                event.endDate = endDay
                event.addRecurrenceRule(rule)

                
                do {
                    try eventStore.saveEvent(event, span: EKSpan.FutureEvents, commit: true)
                }
                catch {
                    print(error)
                }
            }
            
            else {
                
                var tempArr = newCourses[course].midtermdate!.componentsSeparatedByString("/")
                let comp = curCal.components(.Year, fromDate: NSDate())
                comp.month = Int(tempArr[0])!
                comp.day = Int(tempArr[1])!
                //examDay = curCal.dateFromComponents(comp)
                
                tempArr = newCourses[course].start!.componentsSeparatedByString(":")
                comp.hour = Int(tempArr[0])!
                comp.minute = Int(tempArr[1])!
                
                startDay = curCal.dateFromComponents(comp)!
                
                tempArr = newCourses[course].end!.componentsSeparatedByString(":")
                comp.hour = Int(tempArr[0])!
                comp.minute = Int(tempArr[1])!
                
                endDay = curCal.dateFromComponents(comp)!
                
                event.calendar = eventStore.defaultCalendarForNewEvents
                event.title = newCourses[course].course! + newCourses[course].code! + " " + newCourses[course].section!
                event.startDate = startDay
                event.endDate = endDay
                
                do {
                    try eventStore.saveEvent(event, span: EKSpan.FutureEvents, commit: true)
                }
                catch {
                    print(error)
                }
                
                
            }
        }
    }
    
    
    func delCourseCal(theCourse: ClassSchedule) {
        
        let week = newToday.dateByAddingTimeInterval(7 * 24 * 60 * 60)
        let predicate = eventStore.predicateForEventsWithStartDate(newToday, endDate: week, calendars: nil)
        let events = eventStore.eventsMatchingPredicate(predicate) as[EKEvent]
        let secArr = theCourse.section!.componentsSeparatedByString(" ")
        
        if events.isEmpty == false {
            
            for event in events{
               
                if secArr[0] == "TST" {
                    
                    
                }
                
                else if event.title == theCourse.course! + theCourse.code! + " " + theCourse.section! {
                    
                    do {
                        try eventStore.removeEvent(event, span: EKSpan.FutureEvents, commit: true)
                    }
                    catch {
                        print(error)
                    }
                    break
                }
            }
        }
        else {
            print("EVENT ERROR -- no event to remove")
        }
        
        
    }
    
}