//
//  MockData.swift
//  WeatherOsijek
//
//  Created by COBE Osijek on 10/08/2017.
//  Copyright © 2017 COBE Osijek. All rights reserved.
//

import Foundation
@testable import WeatherOsijek

struct MockData {
    
    static let forecast = Forecast(temp: "22", weatherDescription: "sunny", date: "Friday", icon: nil)
    static let mockWeatherDetail = WeatherDetail(shortDesc: "sunny", longDesc: "weather is sunny", weatherIcon: nil, weatherID: 999)
    static let weather = Weather(parsingURL: URL(string: "https://www.google.com")!, weatherDesc: MockData.mockWeatherDetail, currentTemp: 10.5, pressure: 100, humidity: 100, tempMin: 100, tempMax: 100, visibility: 100, windSpeed: 10.5, windDegree: 10.5)
    
    static let mockJson: [String: Any] = [
        "main": [
            "clouds": 0,
            "dt": 1502359200,
            "humidity": 29,
            "pressure": 1015,
            "humidity": 10,
            "temp_min": 25,
            "temp_max": 37,
            "temp": 36.26
        ],
        "visibility": 20,
        "weather": [[
            "description": "clear",
            "icon": "01d",
            "id": 800,
            "main": "Clear"
        ]],
        "wind": [
            "speed": 13.3,
            "deg": 9.8
        ]
    ]
    
    static let forecasts = Forecasts(json: mockJson, url: URL(string: "https:\\image.com")!)
}
