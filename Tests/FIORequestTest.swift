//
//  FIORequestTest.swift
//  common
//
//  Created by CK Guven on 10/27/15.
//  Copyright © 2015 CK Guven. All rights reserved.
//

import XCTest

class FIORequestTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLatLongRequest() {
        let server = ForecastIO(apiKey: "myAPIKEY")
        let req = FIORequest(lat: 10.1234, lon: -20.99)
        let expect = "https://api.forecast.io/forecast/myAPIKEY/10.1234,-20.99"
        let result = req.build(server)
        XCTAssertEqual(expect, result)
        
    }
    func testLatLongDateRequest() {
        let server = ForecastIO(apiKey: "myAPIKEY")
        let date = NSDate(timeIntervalSince1970: 1445985798)
        let req = FIORequest(lat: 10.1234, lon: -20.99).withDate(date)
        let expect = "https://api.forecast.io/forecast/myAPIKEY/10.1234,-20.99,1445985798"
        let result = req.build(server)
        XCTAssertEqual(expect, result)
        
    }

}
