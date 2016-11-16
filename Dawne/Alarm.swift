//
//  Alarm.swift
//  Dawne
//
//  Created by JUNGJAE on 3/26/16.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import Foundation
import UIKit

class Alarm {
	var alarm_time: NSDate!
	var media_name: String!
	var media_file: String!
	var is_turn_on: Bool!
	var shake_to_wake: Bool!
	var smooth_wake_option: Bool!
	var snooze_on: Bool!
	
	init() {
		alarm_time = NSDate()
		media_name = "ring_tone_1"
		media_file = "wav"
		is_turn_on = false
		snooze_on = false
		shake_to_wake = true
		smooth_wake_option = true
	}
	
	static let sharedInstance = Alarm()
	
	/* Getters */
	
	func get_media_name() -> String! {
		return media_name
	}
	
	func get_media_file() -> String! {
		return media_file
	}
	
	func get_is_turn_on() -> Bool! {
		return is_turn_on
	}
	
	func get_is_snooze_on() -> Bool! {
		return snooze_on
	}
	
	func get_is_shake_on() -> Bool! {
		return shake_to_wake
	}
	
	func get_is_smooth_on() -> Bool! {
		return smooth_wake_option
	}
	
	/* Setters */
	
	func set_alarm_time(value: NSDate!) {
		alarm_time = value
	}
	
	func set_is_turn_on(value: Bool!) {
		is_turn_on = value
	}
	
	func set_snooze_on(value: Bool!) {
		snooze_on = value
	}
	
	func set_shake_to_wake(value: Bool!) {
		shake_to_wake = value
	}
	
	func set_smooth_on(value: Bool!) {
		smooth_wake_option = value
	}
}