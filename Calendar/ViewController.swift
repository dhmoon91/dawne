//
//  ViewController.swift
//  Calendar
//
//  Created by Hyewook Song on 2/6/16.
//  Copyright © 2016 It's too early. All rights reserved.
//
//Modified function: viewDidLoad()
//Added function: storeChanged()
//Capabilities: background fetch, remote notifications
//info.plist probably changed

import UIKit
import EventKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //CalendarFunc
        calendar().accessCalendar()
        
        //CalcAlarm
        //input integer number in minutes: 1hour 30minute = 90 minutes
        calcAlarm().getMorAlarm(30)
        calcAlarm().getNightAlarm(30, sleep: 400)
        
        //Get notification from background fetch(app delegate) if Calendar database is changed
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "storeChanged",
            name: EKEventStoreChangedNotification,
            object: eventStore)
    }

    //Selector called after NSNotificationCenter is notified
    func storeChanged() {
        
        // Update UI 
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

