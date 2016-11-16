//
//  Scheduler.swift
//  Dawne
//
//  Created by JUNGJAE on 3/26/16.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import Foundation
import UIKit

class Scheduler {
	static let sharedInstance = Scheduler()
	
	/* Setting notification setting */
	func setupNotificationSettings() {
		//let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
		let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound]
		
		// Specify the notification actions.
		let stopAction = UIMutableUserNotificationAction()
		stopAction.identifier = "myStop"
		stopAction.title = "OK"
		stopAction.activationMode = UIUserNotificationActivationMode.Background
		stopAction.destructive = false
		stopAction.authenticationRequired = false
		
		let snoozeAction = UIMutableUserNotificationAction()
		snoozeAction.identifier = "mySnooze"
		snoozeAction.title = "Snooze"
		snoozeAction.activationMode = UIUserNotificationActivationMode.Background
		snoozeAction.destructive = false
		snoozeAction.authenticationRequired = false
		
		let actionsArray = [UIUserNotificationAction](arrayLiteral: stopAction, snoozeAction)
		let actionsArrayMinimal = [UIUserNotificationAction](arrayLiteral: snoozeAction, stopAction)
		
		// Specify the category related to the above actions.
		let alarmCategory = UIMutableUserNotificationCategory()
		alarmCategory.identifier = "myAlarmCategory"
		alarmCategory.setActions(actionsArray, forContext: .Default)
		alarmCategory.setActions(actionsArrayMinimal, forContext: .Minimal)
		
		let categoriesForSettings = Set(arrayLiteral: alarmCategory)
		
		// Register the notification settings.
		let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings)
		UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
	}
	
	func cancel_all_alarm() {
		UIApplication.sharedApplication().cancelAllLocalNotifications()
	}
	
	// Scheduling an alarm called by the main model
	func schedule_an_alarm (date: NSDate, alarm: Alarm) {
		cancel_all_alarm()

		let notification = UILocalNotification()
		notification.fireDate = date
		notification.alertBody = "ALARM"
		notification.alertAction = "Alarm Alert"
		notification.soundName = alarm.get_media_name() + alarm.get_media_file()
		notification.userInfo = ["smooth_wake_option": alarm.get_is_smooth_on()]
		
		print("in scheduling")
		print(date)
		print("current Time")
		print(NSDate())
		
		setupNotificationSettings()
		Model.sharedInstance.rescheduleHelperNewAlarmTime(date)
		alarm.set_alarm_time(date)
		alarm.set_is_turn_on(true)
		UIApplication.sharedApplication().scheduleLocalNotification(notification)
	}
	
	// Function to reschedule an alarm used for snooze
	func reschedule(date: NSDate, alarm: Alarm) {
		schedule_an_alarm(date, alarm: alarm)
	}		
}

