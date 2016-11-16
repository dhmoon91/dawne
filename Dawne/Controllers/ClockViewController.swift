//
//  ClockViewController.swift
//  Dawne
//
//  Created by Gray Jin on 2016-02-19.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class ClockViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeOfDay: UILabel!
    @IBOutlet weak var alarmTime: UILabel!
    
    var MODEL = Model.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        updateClock()
        getAlarmTime()
    }
    
    func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateClock", name: "setTime", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getAlarmTime", name: "alarmChanged", object: nil)
    }
    
    func updateClock() {
        timeLabel.text = MODEL.time
        dateLabel.text = MODEL.date
        timeOfDay.text = MODEL.timeOfDay
    }
    
    func getAlarmTime() {
        alarmTime.text = MODEL.getAlarmTime()
    }
}