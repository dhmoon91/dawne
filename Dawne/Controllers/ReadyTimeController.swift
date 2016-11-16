//
//  ReadyTimeController.swift
//  Dawne
//
//  Created by Chenshuo  Jin on 2016-03-29.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class ReadyTimeController: NewReadyTimeController{

    @IBAction func done(sender: AnyObject) {
        MODEL.timeToGetReady = readyTime
        dismissViewControllerAnimated(true, completion:  nil)
    }

}
