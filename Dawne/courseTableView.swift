//
//  courseTableView.swift
//  Dawne
//
//  Created by Stanley Moon on 2016-02-15.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import Foundation

import UIKit

class courseTableViewController: UITableViewController {
    var test: String?
    var courseName2: String?
    var codeName2: String?
    
    var classTable = [ClassSchedule]()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //5 rows
        
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath:indexPath)
        print("Pass it to tableview \(courseName2) ")
        print("Pass it to tableview \(codeName2) ")
       // var count = 0

        
       /* getTime( (self.courseName2!), courseCode: (self.codeName2!), completion:{(success:[ClassSchedule]) -> Void in
                //count = classes[0].total!
                print("TOTAL CKASSESSSs \(count) ")
                dispatch_async(dispatch_get_main_queue(),{
                    self.tableView.reloadData()
                 
                        cell.textLabel?.text = "\(classes[indexPath.row].section!) Start Time: \(classes[indexPath.row].start!) End Time:\(classes[indexPath.row].end!)"
                });
                
        })*/
        return cell
    }
    
 
    
    
}

