//
//  StudentCoursesController.swift
//  Dawne
//
//  Created by Gray Jin on 2016-02-21.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class StudentCoursesController: UITableViewController {
    
    var MODEL = Model.sharedInstance
    var calendarModel = calendar()
    var courseList = [ClassSchedule]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCourseList()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getCourseList", name: "updatedCourses", object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courseList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as? ListCell {
            let curCourse = courseList[indexPath.row]
            
            let title = curCourse.course!
            let code = curCourse.code!
            let section = curCourse.section!
            let start = curCourse.start!
            let end = curCourse.end!
            let days = curCourse.days!
            var location = "Unknown"
            if curCourse.building != nil && curCourse.room != nil {
                location = "\(curCourse.building!) \(curCourse.room!)"
            } else {
                print("Unable to get room info")
            }
            
            cell.configureCell(title, courseCode: code, section: section, days: days, sTime: start, eTime: end, location: location, index: indexPath.row)
            
            return cell
            
        }
        
        return ListCell()
    }
    
    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion:  nil)
    }
    
    /*@IBAction func Delete(sender: UIButton) {
    print("DELETE PRESSED")
    
    }*/
    
    func getCourseList() {
        courseList = MODEL.courseSchedule
        dispatch_async(dispatch_get_main_queue(),{
            self.tableView.reloadData()
        })
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
    // Configure the cell...
    return cell
    }
    */
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            calendarModel.delCourseCal(courseList[indexPath.row])
            courseList.removeAtIndex(indexPath.row)
         
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            print("DELETED")
            
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}