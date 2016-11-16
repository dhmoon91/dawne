//
//  ViewController.swift
//  Dawne
//
//  Copyright © 2016 It's Too Early. All rights reserved.
//
//
//  ViewController.swift
//  deegeu-swift-rest-example
//
//  Created by Daniel Spiess on 9/23/15.
//  Copyright © 2015 Daniel Spiess. All rights reserved.
//

import UIKit

//var classes = [ClassSchedule]()

//var classesTemp = [ClassSchedule]()
var string1: String = String()
var string2: String = String()

class ViewController: UIViewController {
    
    var courseList = CourseList()
    // var courseList =  CourseList()._listOfCourses
    
    @IBOutlet weak var coursePresent: UILabel!
    @IBOutlet weak var sectionPresent: UILabel!
    @IBOutlet weak var timePresent: UILabel!
    @IBOutlet weak var locPresent: UILabel!
    @IBOutlet weak var dayPresent: UILabel!
    
    @IBOutlet weak var coursePresent2: UILabel!
    @IBOutlet weak var sectionPresent2: UILabel!
    @IBOutlet weak var timePresent2: UILabel!
    @IBOutlet weak var locPresent2: UILabel!
    @IBOutlet weak var dayPresent2: UILabel!
    
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var codeName: UITextField!
    //var classes = [classSchedule]?.self
  
    
    @IBAction func submitCourse(sender: AnyObject) {
       // print("Enter")
        string1 = courseName.text!
        string2 = codeName.text!
       

        courseList.getTime((courseName.text!), courseCode: (codeName.text!))
    }
    
    //MARK: - viewcontroller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //add listner
        addClassObservers()
        print("HEIHEF")
       
    }
    
    func addClassObservers()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateView", name: "getClass", object: nil)
    }
    
    func updateView() {
        //label.text = courseList[0].~
        dispatch_async(dispatch_get_main_queue(),{
        print ("IN UPDATE VIEW FUNCTION \(self.courseList._listOfCourses[0].total)")
        let count = self.courseList._listOfCourses[0].total
        self.coursePresent.text = "\(self.courseList._listOfCourses[0].course!) \(self.courseList._listOfCourses[0].code!) "
        self.sectionPresent.text = self.courseList._listOfCourses[0].section!
        self.timePresent.text = "\(self.courseList._listOfCourses[0].start!) ~ \(self.courseList._listOfCourses[0].end!) "
        self.locPresent.text = "\(self.courseList._listOfCourses[0].building!)\(self.courseList._listOfCourses[0].room!) "
        self.dayPresent.text = self.courseList._listOfCourses[0].days!
            if count > 1 {
            self.coursePresent2.text = "\(self.courseList._listOfCourses[1].course!) \(self.courseList._listOfCourses[1].code!) "
            self.sectionPresent2.text = self.courseList._listOfCourses[1].section!
            self.timePresent2.text = "\(self.courseList._listOfCourses[1].start!) ~ \(self.courseList._listOfCourses[1].end!) "
            self.locPresent2.text = "\(self.courseList._listOfCourses[1].building!)\(self.courseList._listOfCourses[1].room!) "
            self.dayPresent2.text = self.courseList._listOfCourses[1].days!
            }

        })
            //update labels and stuff
    }
    
}
