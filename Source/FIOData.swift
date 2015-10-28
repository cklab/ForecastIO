//
//  FIOData.swift
//  ForecastIO
//
//  Created by CK Guven on 10/28/15.
//
//

import Foundation

public class FIOData {
    
    public var time: NSDate!
    public var summary: String!
    public var icon: String?
    public var temperature: Double!
    public var humidity: Double!
    
    init(data: Dictionary<String, AnyObject>) {
        if let unixTime = data["time"] as? Double {
            self.time = NSDate(timeIntervalSince1970: unixTime)
        } else {
            print("ForecastIO: unix time not found")
        }
        
        if let summary = data["summary"] as? String {
            self.summary = summary
        } else {
            print("ForecastIO: summary not found")
        }
        
        if let icon = data["icon"] as? String {
            self.icon = icon
        }
        
        if let temp = data["temperature"] as? Double {
            self.temperature = temp
        } else {
            print("ForecastIO: temperature not found")
        }
        
        if let humidity = data["humidity"] as? Double {
            self.humidity = humidity
        } else {
            print("ForecastIO: humidity not found")
        }
    }
}