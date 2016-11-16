//
//  SettingsController.swift
//  Dawne
//
//  Created by Gray Jin on 2016-02-21.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    var MODEL = Model.sharedInstance

    @IBOutlet weak var preferedAlarm: UILabel!
    @IBOutlet weak var sleepTime: UILabel!
    @IBOutlet weak var rssFeed: UILabel!
    
    @IBOutlet weak var autoSet: UISwitch!
    @IBOutlet weak var travelMethod: UILabel!
    @IBOutlet weak var wakeReminders: UISwitch!
    
    @IBOutlet weak var snooze: UILabel!
    @IBOutlet weak var alarmSound: UILabel!
    
    @IBOutlet weak var smoothWake: UISwitch!
    
    @IBOutlet weak var readyTime: UILabel!
    @IBOutlet weak var shakeToWake: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set_values()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        set_values()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func set_values() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "hh:mm aa"
        self.preferedAlarm.text = dateFormatter.stringFromDate(MODEL.defaultAlarm)
        self.sleepTime.text = "\(MODEL.sleepTime) h"
        self.rssFeed.text = MODEL.rssFeed
        
        self.autoSet.on = MODEL.autoSet
        self.travelMethod.text = MODEL.travelMethod
        self.snooze.text = "\(MODEL.snooze) m"
        self.wakeReminders.on = MODEL.wakeReminder
        self.alarmSound.text = MODEL.alarmSound
        self.smoothWake.on = MODEL.smoothWake
        
        self.readyTime.text = formatReadyTime(MODEL.timeToGetReady)
        
    }
    
    func formatReadyTime(time: Int) -> String {
        let hours = time/60
        let minutes = time % 60
        if(hours == 0) {
            return "\(minutes)m"
        }
        return "\(hours)h \(minutes) m"
    }

    // MARK: - Table view data source

    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion:  nil)
    }
    
    
    @IBAction func toggleAutoAlarm(sender: AnyObject) {
        MODEL.autoSet = autoSet.on
    }
    
    
    @IBAction func toggleSmoothWake(sender: AnyObject) {
        MODEL.smoothWake = smoothWake.on
    }
    
    @IBAction func toggleWakeReminders(sender: AnyObject) {
        MODEL.wakeReminder = wakeReminders.on
    }

    @IBAction func toggleShakeToWake(sender: AnyObject) {
        MODEL.shakeToWake = shakeToWake.on
    }
}
