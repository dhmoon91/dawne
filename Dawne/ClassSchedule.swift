//
//  ClassSchedule.swift
//  Dawne
//
//  Created by Stanley Moon on 2016-02-14.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import Foundation
class ClassSchedule {
    var course: String? //Course: Subject name 'CS'
    var code: String?    //Code: Code number '446'
    var section: String? //Section: Section number '001'
    var days: String?   //days: days on a week when the class is held 'MWF' or 'WF' ...
    var parsedDays:[String]? //parsedDays: parsed days for calender event addition
    var start: String? //start: Start time of lecture
    var end: String? //end: end time of lecture
    var building: String? //building: Where the lecture is held 'MC'
    var room: String? //room: room number of the building '4045'
    var total: Int? //total: total number of sections, including TST, TUT
    var term: String? //term: number presentation of the current term '1161'
    var midtermdate: String? //date: Exact date when the section is held, for TST sections
    
    
    
    
    init(course: String, code: String, section: String, days: String, parsedDays:[String],  start: String, end: String, building: String, room: String, total: Int, term: String, midtermdate: String)
    {
        self.course = course
        self.code = code
        self.section = section
        self.days = days
        self.parsedDays = parsedDays
        self.start = start
        self.end = end
        self.building = building
        self.room = room
        self.total = total
        self.term = term
        self.midtermdate = midtermdate
        
    }
    
    
    
}

class CourseList: NSObject {
    var _listOfCourses =  [ClassSchedule]()
    var listCourses: [ClassSchedule] {
        get {
            return _listOfCourses
        }
    }
    
    func parseWeek( count: Int , classes: [ClassSchedule])
    {
        var temp: String = "nil"
        if classes[count].days != nil
        {
            temp = classes[count].days!
        }
        //var temp: String = classes[count].days!
        print("Days during the week: " + temp)
        let countTemp = (temp.characters.count) - 1
        var countTemp2 = countTemp
        
        for var index = 0; index <= countTemp; index++
        {
            
            print("Value of index: \(index) ")
            //print("Value of length of temp + \(countTemp) ")
            //if next character is Uppercase, add space
            
            //check if next char is uppercase or not
            if (index != countTemp2)
            {
                let checkchar = temp[temp.startIndex.advancedBy(index+1)]
                print("Current Character \(checkchar) ")
                let str = String(checkchar)
                if str.rangeOfCharacterFromSet(NSCharacterSet.lowercaseLetterCharacterSet()) != nil
                {
                    print("Lower case")
                    //temp.insert(" " as Character, atIndex:temp.startIndex.advancedBy(index+1))
                    //index++
                    
                }
                else if str.rangeOfCharacterFromSet(NSCharacterSet.uppercaseLetterCharacterSet()) != nil
                {
                    print("Upper case")
                    temp.insert(" " as Character, atIndex:temp.startIndex.advancedBy(index+1))
                    index++
                    countTemp2++
                }
                
            }
            
            //print("Word position \(temp.startIndex.advancedBy(index)) ")
            print("ADDED SPACE: " + temp)
            
        }
        
        classes[count].parsedDays = temp.componentsSeparatedByString(" ")
        
        for var indexTemp = 0; indexTemp < classes[count].parsedDays!.count ; indexTemp++
        {
            print("PARSED DAY #1 \(classes[count].parsedDays![indexTemp])");
        }
        
    }
    //////end of parseWeek function
    
    
    func getTime(courseName: String, courseCode: String  ){
        // private let waterlooAPIKey="69328de95fac4a0b0cd20fef8038e179"
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "https://api.uwaterloo.ca/v2/courses/\(courseName)/\(courseCode)/schedule.json?key=69328de95fac4a0b0cd20fef8038e179"
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        
        var classes = [ClassSchedule]()
        // Make the POST c all and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            // Read the JSON
            do {
                let data: NSData? = NSData(contentsOfURL: url)
                if let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                {
                    //////ARRAY///////
                    let dataArray = jsonResult["data"] as! NSArray
                    //////
                    let arrayLength = dataArray.count
                    var count = 0
                    //classes.append(ClassSchedule(course: item["subject"] as! String, code: item["catalog_number"] as! String, section: item["section"] as! String) )
                    
                    print("TOTAL OF CLASSES: \(arrayLength)");
                    
                    for item in dataArray
                    {
                        
                        classes.append(ClassSchedule(course: "TEMP", code: "TEMP", section: "TEMP", days:"TEMP", parsedDays:["TEMP"], start:"TEMP", end:"TEMP", building:"TEMP", room:"TEMP", total: arrayLength, term:"TEMP", midtermdate:"TEMP") )
                        
                        classes[count].course = (item["subject"] as! String)
                        classes[count].code = (item["catalog_number"] as! String)
                        classes[count].section = (item["section"] as! String)
                        
                        ////////////Get which term we are in//////////
                        var termNumber = (item["term"] as! Int)
                        termNumber = termNumber % 10
                        
                        //1161= middle 16 represents year, last 1 represents month;Jan thus Winter 16 term, Jan~Apr
                        //1165= Spring 16 term, May~Aug
                        switch termNumber {
                        case 1:
                            classes[count].term = "Winter"
                        case 5:
                            classes[count].term = "Spring"
                        case 9:
                            classes[count].term = "Fall"
                        default:
                            print("NO WAY!")
                            
                        }
                        
                        print("DID WE GET TERM??? \(classes[count].term)")
                        /////////////////////////////////////////////////////
                        
                        print("Subject: \(classes[count].course!) \(classes[count].code!)");
                        print("Section: \(classes[count].section!)");
                        
                        let subjectArray = item["classes"] as! NSArray
                        let dateDictionary = subjectArray[0]["date"] as! NSDictionary
                        
                        classes[count].days = (dateDictionary["weekdays"] as? String)
                        //Parse weekdays separately.
                        self.parseWeek(count, classes: classes)
                        
                        
                        classes[count].start = (dateDictionary["start_time"] as? String)
                        classes[count].end = (dateDictionary["end_time"] as? String)
                        classes[count].midtermdate = (dateDictionary["end_date"] as? String)
                        
                        print("Weekdays: \(classes[count].days)");
                        print("START TIME: \(classes[count].start)");
                        print("End Time: \( classes[count].end)");
                        print("Midtermdate(Only for TST section) : \( classes[count].midtermdate)");
                        
                        let locationDictionary = subjectArray[0]["location"] as! NSDictionary
                        classes[count].building = (locationDictionary["building"] as? String)
                        classes[count].room = (locationDictionary["room"] as? String)
                        print("Building: \(classes[count].building) \(classes[count].room)");
                        
                        
                        count += 1
                        
                        print("")
                        
                    }
                    //let subject = dataArray["subject"]
                }
                
            } catch {
                print("bad things happened")
            }
            self._listOfCourses = classes
            //print("HIASIDHASIDHASDHIASDI")
            //print(self._listOfCourses[0].end)
            NSNotificationCenter.defaultCenter().postNotificationName("getClass", object: nil)
            
        }).resume()
    }
    
    
    
}




//NSNotificationCenter.defaultCenter().addObserver(self, selector: "myFunction", name: "finishedCalendarCalc", object: nil)