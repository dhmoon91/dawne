//
//  AlarmViewController.swift
//  Dawne
//
//  Created by Gray Jin on 2016-02-19.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var MODEL = Model.sharedInstance

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alarmTime: UILabel!
    @IBOutlet weak var timeOfDay: UILabel!
    
    var imageArray = ["event", "sun", "travel_icon"]
    
    var titleArray = ["First Event of Tomorrow", "Time to Get Ready", "Estimated Travel Time"]
    
    var timeArray = ["11:30AM", "1h25m", "30m"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        addObservers()
        getAlarmTime()
    }
    
    func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getAlarmTime", name: "alarmChanged", object: nil)
    }
    
    func getAlarmTime() {
        var stringList = MODEL.getAlarmTime().componentsSeparatedByString(" ")
        
        alarmTime.text = stringList[0]
        timeOfDay.text = stringList[1]
        
        timeArray[0] = MODEL.firstEventTime
        
        titleArray[0] = MODEL.firstEventName
        
        let wakeUpTime = MODEL.timeToGetReady
        if wakeUpTime >= 60 {
            let minutes = wakeUpTime % 60
            let hours = wakeUpTime / 60
            timeArray[1] = "\(hours)h\(minutes)m"
        } else {
            timeArray[1] = "\(wakeUpTime)m"
        }
        
        let estimatedTravel = MODEL.estimatedTravelTime
        
        if estimatedTravel >= 60 {
            let minutes = estimatedTravel % 60
            let hours = estimatedTravel / 60
            timeArray[2] = "\(hours)h\(minutes)m"
        } else {
            timeArray[2] = "\(estimatedTravel)m"
        }
        
        dispatch_async(dispatch_get_main_queue(),{
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("AlarmCell") as? AlarmCell {
            
            let img = UIImage(named: imageArray[indexPath.row])
            let title = titleArray[indexPath.row]
            let cellText = timeArray[indexPath.row]
            
            cell.configureCell(img!, title: title, text: cellText)
            return cell
        }
        
        return AlarmCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
}
