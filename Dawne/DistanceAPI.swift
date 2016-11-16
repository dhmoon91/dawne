//
//  DistanceAPI.swift
//  Dawne
//
//  Created by Nicholas on 2/20/16.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import Foundation
import Alamofire
import MapKit

public class DistanceAPI: NSObject {
    private var url: String!
    private var key: String!
    private var default_method: String!
    public var expected_time: Int!
    private var data_ready: Bool!
    
    override init() {
        super.init()
        self.url = "https://maps.googleapis.com/maps/api/distancematrix/json"
        self.key = "AIzaSyC0rehPYYtdUnmahq7bBwTgQUg0qgxq7Og"
        self.default_method = "driving"
        self.expected_time = 0
        self.data_ready = false
    }
    
    public func is_data_ready() -> Bool! {
        return data_ready;
    }
    
    public func get_expected_time() -> Int! {

        if data_ready == true {
            return expected_time;
        }else {
            return -1;
        }
    }
    
    public func set_data_ready(value: Bool) {
        self.data_ready = value
    }
    
    public func set_expected_time(value: Int) {
        expected_time = value
        data_ready = true

        NSNotificationCenter.defaultCenter().postNotificationName("finishedExpectedTime", object: nil)
    }
    
    //Public function that returns expected travelling time
    public func distance(departure: String, destination: String, method: String, arr_time: Int) {
        let requestParameters = [
            "origins" : departure,
            "destinations" : destination,
            "mode" : method,
            "arrival_time" : arr_time,
            "key" : key
        ]
        
		Alamofire.request(.GET, self.url, parameters: requestParameters as! [String: AnyObject]).responseJSON { response in
            if response.result.isFailure {
                NSLog("Error: GET failed")
                return
            }
            
            //Parsing the JSON Object using NSJOSNSerialization class
            if let JSON = response.result.value {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    if let rows = json["rows"] as? [[String: AnyObject]] {
                        for row in rows {
                            if let elements = row["elements"] as? [[String: AnyObject]] {
                                for element in elements {
                                    if let distances = element["duration"] as? [String: AnyObject] {
                                        let value = distances["value"] as! Int
                                        self.set_expected_time(value)
										print(value)
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                }
            }
        }
    }
}