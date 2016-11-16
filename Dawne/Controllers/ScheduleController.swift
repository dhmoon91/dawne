//
//  ScheduleController.swift
//  Dawne
//
//  Created by Gray Jin on 2016-02-19.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class ScheduleController: UITableViewController {
    
    let MODEL = Model.sharedInstance
    var eventArray = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        getEvents()

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
        return eventArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("Starting my thing")
        if let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleRow") as? ScheduleViewCell {
            let curEvent = eventArray[indexPath.row]
            
            let startTimeRaw = curEvent.startTime.componentsSeparatedByString(" ")
            let endTimeRaw = curEvent.endTime.componentsSeparatedByString(" ")
            
            let startTime = startTimeRaw[0]
            let startToD = startTimeRaw[1]
            let endTime = endTimeRaw[0]
            let endToD = endTimeRaw[1]
            
            cell.configureCell(startTime,
                eTime: endTime,
                sTOD: startToD,
                eTOD: endToD,
                name: curEvent.title,
                location: curEvent.location)
            
            return cell
        }
        
        return ScheduleViewCell()
    }
    
    func getEvents () {
        eventArray = MODEL.getCalendarEvents()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
