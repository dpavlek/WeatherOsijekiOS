//
//  ViewModel.swift
//  WeatherOsijek
//
//  Created by COBE Osijek on 09/08/2017.
//  Copyright © 2017 COBE Osijek. All rights reserved.
//

import Foundation

class ViewModel {
    
    var forecastObject: Forecasts?
    var weatherObject: Weather?
    var fetcher: FetchesJSON
    
    init(fetcher: FetchesJSON){
        self.fetcher = fetcher
    }
    
    enum weatherInfo {
        case description, temperature, windspeed, icon
    }
    
    let weatherURL = URL(string: Constants.weatherURLString)!
    let forecastURL = URL(string: Constants.forecastURLString)!
    
    func fetchWeather(onCompletion: @escaping ((String?, String?) -> Void)) {
        fetcher.fetch(fromUrl: weatherURL) { [weak self] json in
            self?.weatherObject = Weather(json: json, url: (self?.weatherURL)!)
            print(json)
            onCompletion("Finished", nil)
        }
    }
    
    func fetchForecast(onCompletion: @escaping ((String?, String?) -> Void)) {
        fetcher.fetch(fromUrl: forecastURL) { [weak self] json in
            //print(json)
            self?.forecastObject = Forecasts(json: json, url: (self?.forecastURL)!)
            onCompletion(nil, nil)
        }
        onCompletion(nil, "Error: Didn't enter closure")
    }
    
    func showWeatherData() -> [String: Any] {
        
        var weatherPackage: [String: Any] = [
            "WeatherDescription": weatherObject?.weatherDesc?.shortDesc ?? "Nil",
            "Temperature": "Temperature: \(String(weatherObject?.currentTemp ?? -273.15)) °C",
            "WindSpeed": "Wind: \(String(weatherObject?.windSpeed ?? 404)) km/h"
        ]
        
        if let weatherIcon = weatherObject?.weatherDesc?.weatherIcon {
            weatherPackage["WeatherIcon"] = weatherIcon
        }
        
        return weatherPackage
    }
    
    func refreshForecasts(onCompletion: @escaping (String?, String?) -> Void) {
        forecastObject?.refreshData { [weak self] forecast in
            self?.forecastObject = forecast
            onCompletion(nil, nil)
        }
        onCompletion(nil, "Error: Didn't enter closure")
    }
    
    func refreshWeather(onCompletion: @escaping (String?, String?) -> Void) {
        weatherObject?.refreshData { [weak self] weather in
            self?.weatherObject = weather
            onCompletion(nil, nil)
        }
        onCompletion(nil, "Error: Didn't enter closure")
    }
    
    func getForecast(forIndex index: Int) -> Forecast? {
        return forecastObject?.forecasts[index]
    }
    
    func getForecastCount() -> Int {
        return forecastObject?.forecasts.count ?? 0
    }
    
}
