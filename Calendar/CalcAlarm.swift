//
//  CalcAlarm.swift
//  Calendar
//
//  Created by Hyewook Song on 2/19/16.
//  Copyright © 2016 It's too early. All rights reserved.
//

import Foundation

class calcAlarm {
    
    //calculates morning alarm by first event datetime - readytime - transportationtime(not implemented)
    //input readytime
    //output alarm in NSDate
    func getMorAlarm(ready: Int) -> NSDate {
        
        let temp = calendar().firstEvent()
        var unixTime = Double()
        var eventTime = NSDate()
        var alarm = NSDate()
        let periodComponents = NSDateComponents()
        
        //convert input minutes
        //NEED TO ADD TRANSPORTATION TIME
        let hour = ready / 60
        let min = ready % 60
    
        if temp != "No events found" {
            
            var tempArr = temp.componentsSeparatedByString(",")
            unixTime = Double(tempArr[0])!
            eventTime = NSDate(timeIntervalSince1970: unixTime)
            
            
            periodComponents.hour = -hour
            periodComponents.minute = -min
            
            alarm = NSCalendar.currentCalendar().dateByAddingComponents(
                periodComponents,
                toDate: eventTime,
                options: [])!
            
        }
        else {
            
            //if no first event found, return 1970/01/01 
            //SHOULD BE CHANGED
            periodComponents.year = 1970
            periodComponents.month = 1
            periodComponents.day = 1
            
            alarm = NSCalendar.currentCalendar().dateFromComponents(periodComponents)!
            
        }
        
        print(alarm)
        
        return alarm
        
    }
    
    
    //calculate night alarm by morningalarm - sleeptime - notificationtime
    //input readytime, sleeptime
    //ouput bedtime in NSDate
    func getNightAlarm(ready: Int, sleep: Int) -> NSDate {
        
        let alarm = getMorAlarm(ready)
        var bed = NSDate()
        let components = NSCalendar.currentCalendar().components([.Year], fromDate: alarm)
        let periodComponents = NSDateComponents()
        
        //add 30 minitues for notification
        let noti = 30
        let hour = (sleep + noti) / 60
        let min = (sleep + noti) % 60

        
        if components.year != 1970 {
            
            periodComponents.hour = -hour
            periodComponents.minute = -min
            
            bed = NSCalendar.currentCalendar().dateByAddingComponents(
                periodComponents,
                toDate: alarm,
                options: [])!
            
        }
        else {
            
            //hmmmmm
            
        }
        
        print(bed)
        
        return bed
        
    }
    
    

    
    
    
}
