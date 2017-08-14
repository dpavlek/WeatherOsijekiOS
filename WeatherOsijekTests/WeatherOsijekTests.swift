//
//  WeatherOsijekTests.swift
//  WeatherOsijekTests
//
//  Created by COBE Osijek on 10/08/2017.
//  Copyright © 2017 COBE Osijek. All rights reserved.
//

import XCTest
@testable import WeatherOsijek

class WeatherOsijekTests: XCTestCase {
    
    var forecast: Forecast!
    var weather: Weather!
    var fetcher: FetcherMock!
    
    var viewModel: ViewModel!
    
    override func setUp() {
        super.setUp()
        
        forecast = MockData.forecast
        fetcher = FetcherMock()
        
        viewModel = ViewModel(fetcher: FetcherMock())
        viewModel.weatherObject = MockData.weather
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testParsingUrlForFetchingWeather() {
        XCTAssertEqual(viewModel.weatherObject?.parsingURL.absoluteString, "https://www.google.com")
    }
    
    func testWeatherDescriptionSetting() {
        XCTAssertEqual((viewModel.weatherObject!.weatherDesc)!, MockData.mockWeatherDetail)
    }
    
    func testWhetherWeatherDetailIsSetCorrectly() {
        let weatherDetail = viewModel.weatherObject?.weatherDesc
        XCTAssertEqual(weatherDetail?.shortDesc, "sunny")
        XCTAssertEqual(weatherDetail?.longDesc, "weather is sunny")
        XCTAssertEqual(weatherDetail?.weatherIcon, nil)
        XCTAssertEqual(weatherDetail?.weatherID, 999)
    }
    
    func testShowWeatherDataFunction() {
        let weatherPackage = viewModel.showWeatherData()
        XCTAssertEqual(weatherPackage["WeatherDescription"] as? String, "sunny")
        XCTAssertEqual(weatherPackage["Temperature"] as? String, "Temperature: 10.5 °C")
        XCTAssertEqual(weatherPackage["WindSpeed"] as? String, "Wind: 10.5 km/h")
    }
    
    func testShowWeatherDataFunctionWhenEverythingIsNil() {
        viewModel.weatherObject = nil
        let weatherPackage = viewModel.showWeatherData()
        XCTAssertEqual(weatherPackage["WeatherDescription"] as? String, "Nil")
        XCTAssertEqual(weatherPackage["Temperature"] as? String, "Temperature: -273.15 °C")
        XCTAssertEqual(weatherPackage["WindSpeed"] as? String, "Wind: 404.0 km/h")
    }
    
    func testFetchingWeather(){
        viewModel.fetchWeather { (message, error) in
            XCTAssertNotNil(self.viewModel.weatherObject)
        }
    }
    
    func testFetchingWeatherError(){
        viewModel.fetchWeather { (message, error) in
            XCTAssertNotNil(error)
        }
    }
}
