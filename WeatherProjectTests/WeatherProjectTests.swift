//
//  WeatherProjectTests.swift
//  WeatherProjectTests
//
//  Created by berfin doksöz on 16.08.2023.
//

import XCTest
@testable import WeatherProject

class WeatherProjectTests: XCTestCase {
    
    func testCanParseWeather(){
        
        let json = """
        {
            "weather": [
            {
                "id": 800,
                "description": "clear sky",
            }
            ],
            "main": {
                "temp": 34.79,
            },
            "name": "Ankara",
        }
        """
        
        let jsonData = json.data(using: .utf8)!
        let weatherData = try! JSONDecoder().decode(WeatherData.self, from: jsonData)

        XCTAssertEqual(34.79, weatherData.main.temp)
        XCTAssertEqual("Ankara", weatherData.name)
    }
}
