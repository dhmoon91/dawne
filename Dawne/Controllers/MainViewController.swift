//
//  MainViewController.swift
//  Dawne
//
//  Created by Gray Jin on 2016-02-19.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class MainViewController: UIViewController {
    
    var MODEL = Model.sharedInstance
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
		let alarm_object: Alarm! = MODEL.get_alarm_object()
		if motion == .MotionShake && alarm_object.get_is_turn_on() == true && alarm_object.get_is_shake_on() == true {
			//let audio_player: AVAudioPlayer! = MODEL.get_audio_player()
			MODEL.stop_the_audio()
			alarm_object.set_is_turn_on(false)
		}
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
