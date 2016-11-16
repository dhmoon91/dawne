//
//  MainModel.swift
//  Dawne
//
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import Foundation
import CoreLocation
import EventKit
import ForecastIO
import AudioToolbox
import AVFoundation
import CoreData

class Model: NSObject, CLLocationManagerDelegate {

    // Singleton Class
    static let sharedInstance = Model()
    var settings = [NSManagedObject]()
    
    var locationManager: CLLocationManager = CLLocationManager()
    var appLocation: CLLocation!
    var longitude:Double = -80.5167
    var latitude:Double = 43.4667
    
    let forecastIOClient = APIClient(apiKey: "da148ebe25f8ef5da0a6ea5a1657877b")
    var currentTemp = WeatherInfo()
    var tempForDay = [WeatherInfo]()
    
    var alarmCalculator: calcAlarm!
    var calendarWrapper: calendar!
	var timer_button: NSTimer? = nil
    
    var _new_user = true

    private var _time: String!
    private var _date: String!
    private var _year: String!
    private var _timeOfDay: String!
    private var timer: NSTimer!
    private var _courseSchedule = [ClassSchedule]()
    private var _firstEventTime = "N/A"
	private var _alarmClass: Alarm!
	private var audio_player: AVAudioPlayer?
    private var _estimatedTravelTime = 0
    
    private var _autoForToday = true
    
    private var _defaultAlarm: NSDate!
    private var _alarm: NSDate!
    private var _timeToGetReady = 90
    private var _snooze = 15
    private var _sleepTime = 8
    private var _travelMethod = "Driving"
    private var _alarmSound = ""
    private var _rssFeed = "Today"
    private var _autoSet = false
    private var _nightReminders = false
    private var _smoothWake = false
    private var _wakeReminder = false
    private var _shakeToWake = false

	//private var _scheduler: Scheduler!
    
    //Getters and Setters
    var time: String {
        get {
            return _time
        }
    }
    
    var timeOfDay: String {
        get {
            return _timeOfDay
        }
    }
    
    var date: String {
        get {
            return _date
        }
    }
    
    var alarm: NSDate {
        get {
            return _alarm
        }
    }
    
    var estimatedTravelTime: Int {
        get {
            return _estimatedTravelTime
        }
    }
    
    var firstEventTime: String {
        get {
            return _firstEventTime
        }
    }
    
    var courseSchedule: [ClassSchedule] {
        get{
            return _courseSchedule
        }
    }
    
    var firstEventName: String {
        get {
            return alarmCalculator.firstEvent
        }
    }
    
    var defaultAlarm: NSDate {
        get{
            return _defaultAlarm
        }
        set(value) {
            _defaultAlarm = value
            nextDay()
            saveSetting("defaultAlarm", value: _defaultAlarm)
        }
    }
    
    //settings
    
    var timeToGetReady: Int {
        get {
            return _timeToGetReady
        }
        set(value){
            _timeToGetReady = value
            saveSetting("timeToGetReady", value: value)
        }
    }
    
    var snooze: Int {
        get {
            return _snooze
        }
        set(value){
            _snooze = value
            saveSetting("snooze", value: value)
        }
    }
    
    var sleepTime: Int {
        get {
            return _sleepTime
        }
        set(value){
            _sleepTime = value
            saveSetting("sleepTime", value: value)
        }
    }
    
    var travelMethod: String {
        get {
            return _travelMethod
        }
        set(value){
            _travelMethod = value
            saveSetting("travelMethod", value: value)
        }
    }
    
    var alarmSound: String {
        get {
            return _alarmSound
        }
        set(value){
            _alarmSound = value
            saveSetting("alarmSound", value: value)
        }
    }
    
    var rssFeed: String {
        get {
            return _rssFeed
        }
        set(value){
            _rssFeed = value
            saveSetting("rssFeed", value: value)
        }
    }
    
    var autoSet: Bool {
        get {
            return _autoSet
        }
        set(value){
            _autoSet = value
            saveSetting("autoSet", value: value)
        }
    }
    
    var nightReminders: Bool {
        get {
            return _nightReminders
        }
        set(value){
            _nightReminders = value
            saveSetting("nightReminders", value: value)
        }
    }
    
    var smoothWake: Bool {
        get {
            return _smoothWake
        }
        set(value){
            _smoothWake = value
            saveSetting("smoothWake", value: value)
        }
    }
    
    var wakeReminder: Bool {
        get {
            return _wakeReminder
        }
        set(value){
            _wakeReminder = value
            saveSetting("wakeReminders", value: value)
        }
    }
    
    var shakeToWake: Bool {
        get {
            return _shakeToWake
        }
        set(value){
            _shakeToWake = value
            saveSetting("shakeToWake", value: value)
        }
    }
    
    var autoForToday: Bool {
        get {
            return _autoForToday
        }
        set(value){
            _autoForToday = value
            saveSetting("autoForToday", value: value)
        }
    }
    
    var new_user: Bool {
        get {
            return _new_user
        }
        set(value){
            _new_user = value
            saveSetting("newUser", value: value)
        }
    }
	
	//need to rewrite this getter function
	func get_alarm_object() -> Alarm! {
		return _alarmClass
	}
    
	
	func get_audio_player() -> AVAudioPlayer! {
		return audio_player
	}
	/*
	//need to rewrite this getter function
	func get_scheduler_object() -> Scheduler! {
		return _scheduler
	}
	*/

    override init () {
        super.init()
        getCurrentTime()
        initialize_settings()
        setObservers()
        forecastIOClient.units = .CA
        
        alarmCalculator = calcAlarm()
        calendarWrapper = calendar()
        calendarWrapper.accessCalendar()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        updateLocation()
        
        startTime()
		
		_alarmClass = createAlarmClass() 
		//_scheduler  = createSchdulerClass()
		audio_player = createAudioPlayer()
        if (autoForToday == true && self._autoSet == true) {
            calculateAlarm()
        }
    }
    
    func initialize_settings() {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        let managedContext = appDelegate!.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Settings")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            settings = results as! [NSManagedObject]
            if settings.count == 0 {
                setDefaultSettings()
            }
            setSettings()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func setDefaultSettings() {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Settings",
                                                        inManagedObjectContext:managedContext)
        let newSettings = NSManagedObject(entity: entity!,
                                           insertIntoManagedObjectContext: managedContext)
        
        newSettings.setValue("default", forKey: "alarmSound")
        newSettings.setValue("today", forKey: "rssFeed")
        newSettings.setValue("driving", forKey: "travelMethod")
        newSettings.setValue(8, forKey: "sleepTime")
        newSettings.setValue(60, forKey: "timeToGetReady")
        newSettings.setValue(10, forKey: "snooze")
        newSettings.setValue(true, forKey: "autoSet")
        newSettings.setValue(true, forKey: "nightReminders")
        newSettings.setValue(true, forKey: "shakeToWake")
        newSettings.setValue(true, forKey: "smoothWake")
        newSettings.setValue(true, forKey: "wakeReminders")
        newSettings.setValue(true, forKey: "autoForToday")
        newSettings.setValue(true, forKey: "newUser")
        let alarmTime = self.createAlarmTime(10, minutes: 0, timeOfDay: "am")
        self._defaultAlarm = alarmTime
        self.setAlarmTime(alarmTime)
        
        newSettings.setValue(self.alarm, forKey: "alarm")
        newSettings.setValue(self.alarm, forKey: "defaultAlarm")
        
        print("finished setting defaults")
        
        do {
            try managedContext.save()
            settings.append(newSettings)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func setSettings() {
        let firstSettings = self.settings.first!
        
        self._defaultAlarm = firstSettings.valueForKey("defaultAlarm") as! NSDate
        self.setAlarmTime(firstSettings.valueForKey("alarm") as! NSDate)
        
        self._timeToGetReady = firstSettings.valueForKey("timeToGetReady") as! Int
        self._sleepTime = firstSettings.valueForKey("sleepTime") as! Int
        self._snooze = firstSettings.valueForKey("snooze") as! Int
        
        self._alarmSound = firstSettings.valueForKey("alarmSound") as! String
        self._rssFeed = firstSettings.valueForKey("rssFeed") as! String
        self._travelMethod = firstSettings.valueForKey("travelMethod") as! String
        
        self._autoSet = firstSettings.valueForKey("autoSet") as! Bool
        self._nightReminders = firstSettings.valueForKey("nightReminders") as! Bool
        self._shakeToWake = firstSettings.valueForKey("shakeToWake") as! Bool
        self._smoothWake = firstSettings.valueForKey("smoothWake") as! Bool
        self._wakeReminder = firstSettings.valueForKey("wakeReminders") as! Bool
        self._autoForToday = firstSettings.valueForKey("autoForToday") as! Bool
        self._new_user = firstSettings.valueForKey("newUser") as! Bool
        
        print("Set my settings!")
    }
    
    func saveSetting(key: String, value: AnyObject){
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        let managedContext = appDelegate!.managedObjectContext
        
        let mySettings = self.settings.first!
        
        mySettings.setValue(value, forKey: key)
        
        do {
            try managedContext.save()
        } catch {
            print("Unable to save \(key) with the value \(value)")
        }
    }
	
	func stop_the_timer(smooth_option: Bool!) {
		if smooth_option == true {
			timer_button?.invalidate()
		}
	}
	
	func createAudioPlayer() -> AVAudioPlayer! {
		var audio_player_local: AVAudioPlayer! = AVAudioPlayer()
		UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
		AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
		let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(_alarmClass.get_media_name(), ofType: _alarmClass.get_media_file())!)
		
		var error: NSError?
		
		do {
			audio_player_local = try AVAudioPlayer(contentsOfURL: url)
		}catch let error1 as NSError {
			error = error1
			audio_player_local = nil
		}
		
		if let err = error {
			print("audioPlayer error \(err.localizedDescription)")
		}
		
		return audio_player_local
	}
	
	//5seconds to increase volume
	func smooth_function() {
		audio_player!.prepareToPlay()
		print("smooth in progress")
		let current_volume: Float! = audio_player!.volume
		
		if (current_volume < 1.0) {
			audio_player!.volume = current_volume + 0.1
		}else {
			timer_button?.invalidate()
		}
	}
	
	func play_the_audio(smooth_option: Bool!) {
//		audio_player!.delegate = self
		audio_player!.prepareToPlay()
		
		audio_player?.numberOfLoops = -1
		audio_player!.play()
		
		if smooth_option == true {
			let start_volume: Float! = 0.1
			audio_player!.volume = start_volume
	
			
			print("smooth in progress")
			timer_button = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(Model.smooth_function),
				                                                      userInfo: nil, repeats: true)
			
		}
	}
	
	func stop_the_audio() {
		audio_player!.prepareToPlay()
		audio_player!.stop()
	}
	
    func setObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "calculateAlarm", name: EKEventStoreChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setAutoAlarm", name: "finishedGetMorAlarm", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resetToDefault", name: "noFirstEvent", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recalculate", name: "updatedLocation", object: nil)
    }
    
	//setting an actual alarm (notification) by sending an alarm_time and alarm to the scheduler
	func setAlarm() {
		let _scheduler: Scheduler! = Scheduler.sharedInstance
		//var time: NSDate! = NSDate()
		//var newTime: NSDate! = time.dateByAddingTimeInterval(5)
		let current: NSDate! = NSDate().dateByAddingTimeInterval(86400)
		let later: NSDate! = _alarm.laterDate(current) 
		print("_alarm: ")
		print(_alarm)
		print("current:")
		print(current)
		print("later:" )
		print(later)
		
		
		if _alarm.isEqualToDate(later) == true {
			_alarm = _alarm.dateByAddingTimeInterval(-86400)
		}
		_scheduler.schedule_an_alarm(_alarm, alarm: _alarmClass)
	}
	
	func rescheduleHelperNewAlarmTime(date: NSDate!) {
		_alarm = date
	}
	
    func resetToDefault() {
        self._firstEventTime = "No event"
        self._estimatedTravelTime = 0
        setAlarmTime(_defaultAlarm)
    }
    
    //Set the time
    private func startTime() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "getCurrentTime", userInfo: nil, repeats: true)
    }
    
    func recalculate() {
        if (autoForToday == true){
            calculateAlarm()
        }
    }
    
    func calculateAlarm() {
        autoForToday = true
        alarmCalculator.getMorAlarm(_timeToGetReady, long: longitude, lati: latitude, defaultAlarm:_defaultAlarm)
    }
    
    func setAutoAlarm() {
        let time = alarmCalculator.morningAlarm
        _estimatedTravelTime = alarmCalculator.expectedTime/60
        let temp = alarmCalculator.eventTime
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "hh:mma"
        self._firstEventTime = dateFormatter.stringFromDate(temp)
        setAutoAlarmTime(time)
    }
    
    func getCurrentTime() {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.locale = NSLocale.currentLocale()
        
        dateFormatter.dateFormat = "yyyy"
        _year = dateFormatter.stringFromDate(date)
        
        dateFormatter.dateFormat = "EEE, MMMM d"
        _date = dateFormatter.stringFromDate(date)
        
        dateFormatter.dateFormat = "hh:mm"
        _time = dateFormatter.stringFromDate(date)
        
        dateFormatter.dateFormat = "a"
        _timeOfDay = dateFormatter.stringFromDate(date)
        
        NSNotificationCenter.defaultCenter().postNotificationName("setTime", object: nil)
    }
    
    func setAlarmTime(dateTime: NSDate) {
        _alarm = dateTime
        nextDay()
        updateAlarms()
        print(_alarm)
    }
    
    func setAutoAlarmTime(dateTime: NSDate) {
        _alarm = dateTime
        nextDay()
        if _alarm.earlierDate(_defaultAlarm) == _defaultAlarm {
            _alarm = _defaultAlarm
        }
        updateAlarms()
        print(_alarm)
    }
	
	//creating a singleton alarm object
	func createAlarmClass() -> Alarm! {
		let alarm_object = Alarm()
		
		return alarm_object
	}

	//creating a singleton schduler object
	func createSchdulerClass() -> Scheduler! {
		let schduler_object = Scheduler()
		
		return schduler_object
	}
	
    func createAlarmTime(hour: Int, minutes: Int, timeOfDay: String) -> NSDate {
        let alarm = "\(hour):\(minutes):00 \(timeOfDay), \(_date), \(_year)"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "hh:mm:00 a, EEE, MMMM d, yyyy"
        var alarmTime = dateFormatter.dateFromString(alarm)
        let newDateComponents = NSDateComponents()
        newDateComponents.day = 1
        
        alarmTime = NSCalendar.currentCalendar().dateByAddingComponents(newDateComponents, toDate: alarmTime!, options: NSCalendarOptions.init(rawValue: 0))
		print("Success")
        return alarmTime!
    }
    
    func updateAlarms() {
        NSNotificationCenter.defaultCenter().postNotificationName("alarmChanged", object: nil)
        
        if(!self.new_user) {
            saveSetting("alarm", value: _alarm)
            saveSetting("defaultAlarm", value: _defaultAlarm)
        }
    }
    
    func nextDay() {
        let curDate = NSDate()
        
        while _alarm.earlierDate(curDate) == _alarm {
            let newDateComponents = NSDateComponents()
            newDateComponents.day = 1
            
            _alarm = NSCalendar.currentCalendar().dateByAddingComponents(newDateComponents, toDate: _alarm, options: NSCalendarOptions.init(rawValue: 0))
        }
        
        while _defaultAlarm.earlierDate(curDate) == _defaultAlarm {
            let newDateComponents = NSDateComponents()
            newDateComponents.day = 1
            
            _defaultAlarm = NSCalendar.currentCalendar().dateByAddingComponents(newDateComponents, toDate: _defaultAlarm, options: NSCalendarOptions.init(rawValue: 0))
        }
        
    }
    
    func getAlarmTime() -> String{
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(_alarm)
    }
    
    func getCalendarEvents() ->[Event] {
        return calendarWrapper.allEvent()
    }
    
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        appLocation = locations.last
        longitude = appLocation.coordinate.longitude
        latitude = appLocation.coordinate.latitude
        locationManager.stopUpdatingLocation()
        NSNotificationCenter.defaultCenter().postNotificationName("updatedLocation", object: nil)
    }
    
    func addCourses(newCourses: [ClassSchedule]) {
        for item in newCourses {
            self._courseSchedule.append(item)
        }
        NSNotificationCenter.defaultCenter().postNotificationName("updatedCourses", object: nil)
    }
    
    func searchWeather() {
        forecastIOClient.getForecast(latitude: self.latitude, longitude: self.longitude) { (currentForecast, error) -> Void in
            if let currentForecast = currentForecast {
                if let curWeather = currentForecast.currently {
                    self.currentTemp.summary = curWeather.summary!
                    self.currentTemp.curTemp = "\(round(curWeather.temperature!))\u{00B0}C"
                    self.currentTemp.feelsLike = "\(round(curWeather.apparentTemperature!))\u{00B0}C"
                    self.currentTemp.humidity = "\(round(curWeather.humidity!*100))%"
                    if let daily = currentForecast.daily, let today = daily.data {
                        let todayData = today[0]
                        self.currentTemp.low = "\(round(todayData.temperatureMin!))\u{00B0}C"
                        self.currentTemp.high = "\(round(todayData.temperatureMax!))\u{00B0}C"
                    }
                }
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "ha"
                self.tempForDay = [WeatherInfo]()
                
                if let weather = currentForecast.hourly, let hourly = weather.data {
                    for var i = 0; i < 24; i++ {
                        let time = hourly[i].time
                        let convertedTime = dateFormatter.stringFromDate(time)
                        let temp = "\(round(hourly[i].temperature!))\u{00B0}C"
                        let summary = hourly[i].summary
                        
                        let hourlyWeather = WeatherInfo(time: convertedTime, summary: summary!, curTemp: temp)
                        self.tempForDay.append(hourlyWeather)
                    }
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName("weatherReady", object: nil)
                
            } else if let error = error {
                //  Uh-oh we have an error!
            }
            
        }
    }
}