//
//  NewWakeController.swift
//  Dawne
//
//  Created by Chenshuo  Jin on 2016-03-29.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class NewWakeController: UIViewController {
    
    var MODEL = Model.sharedInstance

    @IBOutlet weak var alarmPicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmPicker.date = MODEL.defaultAlarm
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        MODEL.defaultAlarm = alarmPicker.date
    }


}