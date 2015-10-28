//
//  ForecastIOTest.swift
//  common
//
//  Created by CK Guven on 10/27/15.
//  Copyright © 2015 CK Guven. All rights reserved.
//

import XCTest

class ForecastIOTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetWeather() {
        let weatherReceived = self.expectationWithDescription("Weather Callback")
        let weather = MockForecastIO(apiKey: "myAPIKEY")
        
        weather.forecast(37.7833, lon: 122.4167, date: NSDate(timeIntervalSince1970: 1446052961)) { (success, data, error) -> Void in
            weatherReceived.fulfill()
            if success {
                if let fiodata = data as? FIOData {
                    XCTAssertEqual(0.4, fiodata.humidity)
                    XCTAssertEqual(53.46, fiodata.temperature)
                    XCTAssertEqual(1446052961, fiodata.time.timeIntervalSince1970)
                    XCTAssertEqual("Clear", fiodata.summary)
                    XCTAssertEqual("clear-night", fiodata.icon)
                }
            } else {
                XCTFail("Data not received in the correct format: \(error!.displayError)")
            }
        }
        
        self.waitForExpectationsWithTimeout(20) { (err) -> Void in
            if let _ = err {
                XCTFail("Not all callbacks were called")
            }
        }
        
    }


}


class MockForecastIO: ForecastIO {
    
    override func send(req: FIORequest, completion: FIOCompletion) {
        do {
            if let path = NSBundle(forClass: ForecastIOTest.self).pathForResource("WeatherResponse", ofType: "json") {
                let str = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let json = try NSJSONSerialization.JSONObjectWithData(str, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String, AnyObject>
                if let json = json {
                    completion(success: true, data: json, error: nil)
                } else {
                    completion(success: false, data: nil, error: FIOError(displayText: "Failed to parse weather response file"))
                }
            } else {
                completion(success: false, data: nil, error: FIOError(displayText: "Failed to read the weather response file: path was null"))
            }
        }
        catch {
            completion(success: false, data: nil, error: FIOError(displayText: "Failed to read the weather response file: \(error)"))
        }
        
    }
}