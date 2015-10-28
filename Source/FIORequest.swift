//
//  FIORequest.swift
//  ForecastIO
//
//  Created by CK Guven on 10/28/15.
//
//

import Foundation

public class FIORequest {
    
    private var lat: Double
    private var lon: Double
    private var date: NSDate?
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
    func withCoordinates(lat: Double, lon: Double) -> Self {
        self.lat = lat
        self.lon = lon
        return self
    }
    
    func withDate(date: NSDate) -> Self {
        self.date = date
        return self
    }
    
    func build(api: ForecastIO) -> String {
        
        var url = "\(ForecastIO.ApiServer)/\(api.ApiKey)/\(lat),\(lon)"
        
        if let date = date {
            url += "," + String(Int(date.timeIntervalSince1970))
        }
        return url
    }
}
