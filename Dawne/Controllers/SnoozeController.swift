//
//  SnoozeController.swift
//  Dawne
//
//  Created by Chenshuo  Jin on 2016-03-29.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class SnoozeController: UIViewController {

    var MODEL = Model.sharedInstance
    
    var snoozeTime = 8
    
    @IBOutlet weak var snoozeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        snoozeTime = MODEL.snooze
        updateView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func subtractFromSnooze(sender: AnyObject) {
        if (snoozeTime > 0 && snoozeTime <= 10) {
            snoozeTime -= 1
        } else if (snoozeTime > 10) {
            snoozeTime -= 5
        }
        updateView()
    }
    @IBAction func addToSnooze(sender: AnyObject) {
        if (snoozeTime < 60 && snoozeTime > 10) {
            snoozeTime += 5
        } else if (snoozeTime < 10) {
            
        }
        updateView()
    }
    
    @IBAction func done(sender: AnyObject) {
        MODEL.snooze = snoozeTime
        dismissViewControllerAnimated(true, completion:  nil)
    }
    
    func updateView() {
        snoozeLabel.text = "\(snoozeTime)"
    }

}
