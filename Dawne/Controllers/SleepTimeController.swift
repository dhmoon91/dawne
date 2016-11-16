//
//  SleepTimeController.swift
//  Dawne
//
//  Created by Chenshuo  Jin on 2016-03-29.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class SleepTimeController: NewSleepTimeController {

    @IBAction func done(sender: AnyObject) {
        MODEL.sleepTime = sleepTime
        dismissViewControllerAnimated(true, completion:  nil)
    }
}
