//
//  NewReadyTimeController.swift
//  Dawne
//
//  Created by Chenshuo  Jin on 2016-03-29.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class NewReadyTimeController: UIViewController {
    
    var MODEL = Model.sharedInstance
    var readyTime = 30
    
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var minutes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readyTime = MODEL.timeToGetReady
        updateView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToHours(sender: AnyObject) {
        if(readyTime + 60 < 24*60) {
            readyTime += 60
        }

        updateView()
    }
    
    @IBAction func addToMinutes(sender: AnyObject) {
        if(readyTime + 15 < 24*60) {
            readyTime += 15
        }
        
        updateView()
    }
    
    @IBAction func subtractFromHours(sender: AnyObject) {
        if(readyTime - 60 >= 0) {
            readyTime -= 60
        }
        
        updateView()
    }
    
    @IBAction func subtractFromMinutes(sender: AnyObject) {
        if(readyTime - 15 >= 0) {
            readyTime -= 15
        }
        
        updateView()
    }
    
    func updateView() {
        let hours = readyTime/60
        let minutes = readyTime % 60
        
        self.hours.text = "\(hours)"
        self.minutes.text = "\(minutes)"
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        MODEL.timeToGetReady = readyTime
        MODEL.new_user = false
        MODEL.calculateAlarm()
    }


}
