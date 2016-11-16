//
//  TravelController.swift
//  Dawne
//
//  Created by Chenshuo  Jin on 2016-03-29.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class TravelController: UIViewController {
    var MODEL = Model.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func driving(action: AnyObject) {
        MODEL.travelMethod = "driving"
        dismissViewControllerAnimated(true, completion:  nil)
    }
    @IBAction func walking(action: AnyObject) {
        MODEL.travelMethod = "walking"
        dismissViewControllerAnimated(true, completion:  nil)
    }
    @IBAction func transit(action: AnyObject) {
        MODEL.travelMethod = "transit"
        dismissViewControllerAnimated(true, completion:  nil)
    }
}
