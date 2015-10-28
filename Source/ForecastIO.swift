//
//  ForecastIO.swift
//  common
//
//  Created by CK Guven on 10/27/15.
//  Copyright © 2015 CK Guven. All rights reserved.
//

import Foundation
import Alamofire


public typealias FIOCompletion = (success: Bool, data: AnyObject?, error: FIOError?) -> Void

public class ForecastIO {
    
    public static let ApiServer = "https://api.forecast.io/forecast"
    public var ApiKey: String
    
    let manager : Alamofire.Manager!
    
    public static var shared: ForecastIO!
    
    /// Initialize a new ForecastIO with an API Key.
    /// :apiKey: the API Key
    ///
    public init(apiKey: String) {
        let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        self.manager = Manager(configuration: configuration)
        self.ApiKey = apiKey
        ForecastIO.shared = self
    }
    
    
    /// Send a FIORequest.
    /// :request: request
    /// :completion: callback
    ///
    public func send(request: FIORequest, completion: FIOCompletion) {
        manager.request(.GET, request.build(self)).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (httpRequest, httpResponse, json) -> Void in
            if let error = json.error {
                completion(success: false, data: nil, error: FIOError(error:error))
            } else {
                completion(success: true, data: json.value, error: nil)
            }
        }
    }
    
    /// Get the forecast for at a latitude/longitude pair on a given date.
    /// :lat: latitude
    /// :lon: longitude
    /// :date: date
    ///
    public func forecast(lat: Double, lon: Double, date: NSDate, callback: FIOCompletion) {
        let req = FIORequest(lat: lat, lon: lon).withDate(date)
        send(req) { (success, data, error) in
            var completed = false
            
            if let data = data as? Dictionary<String, AnyObject> {
                if let curr = data["currently"] as? Dictionary<String, AnyObject> {
                    callback(success: true, data: FIOData(data: curr), error: nil)
                    completed = true
                }
            }
            
            if !completed {
                callback(success: false, data: nil, error: error)
            }
        }
    }
    
    /// Get the forecast for at a latitude/longitude pair
    /// :lat: latitude
    /// :lon: longitude
    ///
    public func forecast(lat: Double, lon: Double, callback: FIOCompletion) {
        let req = FIORequest(lat: lat, lon: lon)
        send(req) { (success, data, error) in
            
            var completed = false
            if let data = data as? Dictionary<String, AnyObject> {
                if let curr = data["currently"] as? Dictionary<String, AnyObject> {
                    let parsed = FIOData(data: curr)
                    if parsed.temperature != nil {
                        callback(success: true, data: parsed, error: nil)
                        completed = true
                    }
                }
            }
            
            if !completed {
                callback(success: false, data: nil, error: error)
            }
        }
    }
}

/// Error type for API Call errors
public class FIOError: ErrorType {
    public var displayError: String!
    
    public init(error: ErrorType) {
    }
    
    public init(displayText: String) {
        self.displayError = displayText
    }
}