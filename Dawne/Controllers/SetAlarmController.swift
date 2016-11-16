//
//  SetAlarmController.swift
//  Dawne
//
//  Created by Gray Jin on 2016-02-19.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class SetAlarmController: UIViewController {
    
    var MODEL = Model.sharedInstance
    
    @IBOutlet weak var dateSelector: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateSelector.date = MODEL.alarm
    }
    
    @IBAction func setAutoAlarm(sender: AnyObject) {
        MODEL.calculateAlarm()
		MODEL.setAlarm()
        dismissViewControllerAnimated(true, completion:  nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion:  nil)
    }
    
    @IBAction func Accept(sender: UIButton) {
        print(dateSelector.date)
        MODEL.setAlarmTime(dateSelector.date)
		MODEL.setAlarm()
        MODEL.autoForToday = false
        dismissViewControllerAnimated(true, completion:  nil)
    }
}
