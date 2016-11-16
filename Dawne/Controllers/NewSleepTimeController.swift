//
//  NewSleepTimeController.swift
//  Dawne
//
//  Created by Chenshuo  Jin on 2016-03-29.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class NewSleepTimeController: UIViewController {
    
    var MODEL = Model.sharedInstance
    
    var sleepTime = 8
    
    @IBOutlet weak var sleepTimeLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sleepTime = MODEL.sleepTime
        updateView()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func subtractFromSleep(sender: AnyObject) {
        if (sleepTime > 0) {
            sleepTime -= 1
        }
        updateView()
    }
    @IBAction func addToSleep(sender: AnyObject) {
        if (sleepTime < 24) {
            sleepTime += 1
        }
        updateView()
    }
    
    func updateView() {
        sleepTimeLable.text = "\(sleepTime)"
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        MODEL.sleepTime = sleepTime
    }
    
    
}
