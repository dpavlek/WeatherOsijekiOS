//
//  JsonGetter.swift
//  WeatherOsijek
//
//  Created by COBE Osijek on 19/07/2017.
//  Copyright © 2017 COBE Osijek. All rights reserved.
//

import Foundation
import SwiftyJSON

private extension Date {
    func dayOfWeek(time: Double) -> String {
        
        let todayDate = Date(timeIntervalSince1970: time)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        return formatter.string(from: todayDate as Date).capitalized
    }
}

struct WeatherDetail: Equatable {
    let shortDesc: String
    let longDesc: String
    let weatherIcon: UIImage?
    let weatherID: Int
}

extension WeatherDetail {
    init() {
        shortDesc = ""
        longDesc = ""
        weatherID = 0
        weatherIcon = nil
    }
    
    static func == (lhs: WeatherDetail, rhs: WeatherDetail) -> Bool {
        return lhs.longDesc == rhs.longDesc &&
            lhs.shortDesc == rhs.shortDesc &&
            lhs.weatherIcon == rhs.weatherIcon &&
            lhs.weatherID == rhs.weatherID
    }
}

struct Weather {
    
    let parsingURL: URL
    var weatherDesc: WeatherDetail?
    let currentTemp: Double
    let pressure: Int
    let humidity: Int
    let tempMin: Int
    let tempMax: Int
    let visibility: Int
    let windSpeed: Double
    let windDegree: Double
    
    func refreshData(onCompletion: @escaping (Weather?) -> Void) {
        let fetcher = Fetcher()
        fetcher.fetch(fromUrl: parsingURL) { jsonDataWeather in
            onCompletion(Weather(json: jsonDataWeather, url: self.parsingURL))
        }
    }
}

extension Weather {
    
    init?(json: [String: Any], url: URL) {
        
        let json = JSON(json)
        
        guard let shortDesc = json["weather"][0]["main"].string,
            let longDesc = json["weather"][0]["description"].string,
            let weatherIcon = json["weather"][0]["icon"].string,
            let weatherID = json["weather"][0]["id"].int,
            let temp = json["main"]["temp"].double,
            let pressure = json["main"]["pressure"].int,
            let humidity = json["main"]["humidity"].int,
            let tempMin = json["main"]["temp_min"].int,
            let tempMax = json["main"]["temp_max"].int,
            let visibility = json["visibility"].int,
            let windSpeed = json["wind"]["speed"].double,
            let windDegree = json["wind"]["deg"].double
        else {
            return nil
        }
        
        self.currentTemp = temp
        self.pressure = pressure
        self.humidity = humidity
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.visibility = visibility
        self.windSpeed = windSpeed
        self.windDegree = windDegree
        
        self.parsingURL = url
        
        loadImage(identificator: weatherIcon) { image in
            self.weatherDesc = WeatherDetail(shortDesc: shortDesc, longDesc: longDesc, weatherIcon: image, weatherID: weatherID)
        }
    }
    
}

struct Forecast {
    
    var temp: String
    var weatherDescription: String
    var date: String
    var icon: UIImage?
    
}

struct Forecasts {
    
    let parsingURL: URL?
    var forecasts = [Forecast]()
    
    init?(json: [String: Any], url: URL) {
        
        self.parsingURL = url
        
        guard let forecastsArray = json["list"] as? [[String: Any]]
        else {
            return nil
        }
        
        for day in forecastsArray {
            
            let day = JSON(day)
            
            let temp = day["temp"]["day"].stringValue
            let weatherDescription = day["weather"][0]["main"].string ?? "No Description"
            let date = Date().dayOfWeek(time: day["dt"].doubleValue)
            let iconID = day["weather"][0]["icon"].stringValue
            loadImage(identificator: iconID) { image in
                self.forecasts.append(Forecast(temp: temp, weatherDescription: weatherDescription, date: date, icon: image))
            }
        }
    }
    
    func getForecastCount() -> Int {
        return self.forecasts.count
    }
    
    func refreshData(onCompletion: @escaping ((Forecasts?) -> Void)) {
        
        let fetcher = Fetcher()
        var jsonDataForecast = [String: Any]()
        if let parsingURL = self.parsingURL {
            fetcher.fetch(fromUrl: parsingURL) { json in
                jsonDataForecast = json
                onCompletion(Forecasts(json: jsonDataForecast, url: parsingURL))
            }
        } else {
            print("URL is nil!")
            return
        }
    }
}

private func loadImage(identificator: String, onCompletion: (UIImage?) -> Void) {
    let imageURLString = "http://openweathermap.org/img/w/" + identificator + ".png"
    if let imageURL = URL(string: imageURLString) {
        if let imageData = try? Data(contentsOf: imageURL) {
            onCompletion(UIImage(data: imageData))
        }
    }
}
