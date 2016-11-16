//
//  CalculateAlarm.swift
//  Dawne
//
//  Created by Hyewook Song on 2/20/16.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import Foundation

public class calcAlarm: NSObject {
  
    var expectedTime = Int()
    var morningAlarm = NSDate()
    var nightAlarm = NSDate()
    var readyTime = Int()
    var eventTime = NSDate()
    var defaultAlarm = NSDate()
    var distanceclass = DistanceAPI()
    var calendarclass = calendar()
    
    var firstEvent: String {
        get {
            return calendarclass.firstName
        }
    }
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getExpectedTime", name: "finishedExpectedTime", object: nil)
        calendarclass.accessCalendar()
    }
    
    public func get_morning() -> NSDate {
        
        return morningAlarm
    }
    
    public func get_night() -> NSDate {
        
        return nightAlarm
    }
    
    //calculates morning alarm by first event datetime - readytime - transportationtime
    //input readytime
    //output alarm as NSDate
    func getMorAlarm(ready: Int, long: Double, lati: Double, defaultAlarm: NSDate){
        readyTime = ready
        self.defaultAlarm = defaultAlarm
        let temp = calendarclass.firstEvent()
        var unixTime = Double()
        //var alarm = NSDate()
        // let periodComponents = NSDateComponents()
        
        if temp != "No events found" {
            
            var tempArr = temp.componentsSeparatedByString("/")
            unixTime = Double(tempArr[2])!
            eventTime = NSDate(timeIntervalSince1970: unixTime)
            
            //Map
            //check location is empty
            if tempArr[1].isEmpty {
                
                expectedTime = 0
                getExpectedTime()
            }
            else {
                
                let origin: String! = String(lati) + "," + String(long)
                //method: "walking" or "driving" 
                distanceclass.distance(origin, destination: tempArr[1], method: "transit", arr_time: Int(tempArr[0])!)
                
            }
            
        }
        else {
            morningAlarm = defaultAlarm
            NSNotificationCenter.defaultCenter().postNotificationName("noFirstEvent", object: nil)
            
        }
        
        print(morningAlarm)

        
    }
    
    func getExpectedTime() {
        
        let periodComponents = NSDateComponents()
        
        expectedTime = distanceclass.get_expected_time()
		print("calculated:")
		print(expectedTime)

        //convert input minutes
        let hour = (readyTime + expectedTime/60) / 60
        let min = (readyTime + expectedTime/60) % 60
		
		print("Hour \(hour)")
		print("min \(min)")
        
        periodComponents.hour = -hour
        periodComponents.minute = -min
        
        morningAlarm = NSCalendar.currentCalendar().dateByAddingComponents(
            periodComponents,
            toDate: eventTime,
            options: [])!
    
        //print(expectedTime)
        
        NSNotificationCenter.defaultCenter().postNotificationName("finishedGetMorAlarm", object: nil)
        
    }
    
    
    //calculate night alarm by morningalarm - sleeptime -readytime - notificationtime
    func getNightAlarm(sleep: Int, ready: Int, noti: Int){
        
        let alarm = get_morning()
        let periodComponents = NSDateComponents()
        
        let hour = (sleep + ready + noti) / 60
        let min = (sleep + ready + noti) % 60
        
            
        periodComponents.hour = -hour
        periodComponents.minute = -min
        
        nightAlarm = NSCalendar.currentCalendar().dateByAddingComponents(
            periodComponents,
            toDate: alarm,
            options: [])!
    
        
        print(nightAlarm)
        NSNotificationCenter.defaultCenter().postNotificationName("finishedGetNightAlarm", object: nil)

        
    }
    
}