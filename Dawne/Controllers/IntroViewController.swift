//
//  IntroViewController.swift
//  Dawne
//
//  Created by Chenshuo  Jin on 2016-03-29.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    var MODEL = Model.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!MODEL.new_user){
            auto_segue()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func auto_segue() {
        dispatch_async(dispatch_get_main_queue(),{
            
            self.performSegueWithIdentifier("goToMain", sender: nil)
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
