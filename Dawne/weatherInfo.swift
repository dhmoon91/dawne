//
//  weatherInfo.swift
//  Dawne
//
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import Foundation

class WeatherInfo: NSObject{
    var curTemp: String!
    var summary: String!
    var high: String!
    var low: String!
    var feelsLike: String!
    var humidity: String!
    var time: String!
    
    override init() {
        curTemp = "-\u{00B0}C"
        summary = "Loading..."
        high = "-\u{00B0}C"
        low = "-\u{00B0}C"
        feelsLike = "-\u{00B0}C"
        time = "00:00"
        humidity = "-%"
    }
    
    init(time: String, summary: String, curTemp: String) {
        self.time = time
        self.summary = summary
        self.curTemp = curTemp
        
        high = "-\u{00B0}C"
        low = "-\u{00B0}C"
        feelsLike = "00:00"
        humidity = "-%"
    }
    
}