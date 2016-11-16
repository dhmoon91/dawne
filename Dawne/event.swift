//
//  event.swift
//  Dawne
//
//  Created by Gray Jin on 2016-02-19.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import Foundation

class Event: NSObject {
    var title: String!
    var location: String!
    var startTime: String!
    var endTime: String!
    
    init(title: String, location: String, startTime: String, endTime: String) {
        super.init()
        self.title = title
        self.location = location
        self.startTime = startTime
        self.endTime = endTime
    }
}