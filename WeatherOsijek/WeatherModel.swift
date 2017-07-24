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
    func DayOfWeek(time: Double) -> String {
        
        let todayDate = NSDate(timeIntervalSince1970: time)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        return formatter.string(from: todayDate as Date).capitalized
    }
}

struct WeatherDetail {
    let shortDesc: String
    let longDesc: String
    let weatherIcon: UIImage?
    let weatherID: String
}

extension WeatherDetail {
    init() {
        shortDesc = ""
        longDesc = ""
        weatherID = ""
        weatherIcon = nil
    }
}

struct Weather {
    
    let urlString = "http://api.openweathermap.org/data/2.5/weather?q=Osijek,hr&units=metric&appid=913cd011c39c592225373dd9d19f62b3"
    let parsingURL: URL
    var weatherDesc: WeatherDetail?
    let currentTemp: Double
    let pressure: Double
    let humidity: Double
    let tempMin: Double
    let tempMax: Double
    let visibility: Int
    let windSpeed: Double
    let windDegree: Double
    
    init?(json: [String: Any], urlString: String) {
        
        guard let weathersArray = json["weather"] as? [Any],
            let weathers = weathersArray[0] as? [String: String],
            let shortDesc = weathers["main"],
            let longDesc = weathers["description"],
            let weatherIcon = weathers["icon"],
            let weatherID = weathers["id"],
            let conditions = json["main"] as? [String: Double],
            let temp = conditions["temp"],
            let pressure = conditions["pressure"],
            let humidity = conditions["humidity"],
            let tempMin = conditions["temp_min"],
            let tempMax = conditions["temp_max"],
            let visibility = json["visibility"] as? Int,
            let windSpecs = json["wind"] as? [String: Double],
            let windSpeed = windSpecs["speed"],
            let windDegree = windSpecs["deg"]
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
        self.parsingURL = URL(string: urlString)!

        
        LoadImage(identificator: weatherIcon) { image in
            self.weatherDesc = WeatherDetail(shortDesc: shortDesc, longDesc: longDesc, weatherIcon: image, weatherID: weatherID)
        }
    }
    
    func RefreshData() -> Weather?{
        
        var jsonDataWeather = [String:Any]()
        Fetcher(fromUrl: parsingURL){json in
            jsonDataWeather = json
        }
        return Weather(json: jsonDataWeather, urlString: self.urlString)
    }
}

struct Forecast {
    
    var temp: Double?
    var weatherDescription: String
    var date: String
    var icon: UIImage?
    
}

struct Forecasts {
    
    let urlString = "http://api.openweathermap.org/data/2.5/forecast/daily?id=3193935&units=metric&cnt=7&appid=913cd011c39c592225373dd9d19f62b3"
    let parsingURL: URL
    var forecasts = [Forecast]()
    
    init?(json: [String: Any], urlString: String) {
        
        self.parsingURL = URL(string: urlString)!
        
        guard let forecastsArray = json["list"] as? [[String: Any]]
        else {
            return nil
        }
        
        for day in forecastsArray {
            
            let day = JSON(day)
            
            let temp = day["temp"]["day"].doubleValue
            let weatherDescription = day["weather"][0]["main"].string ?? "No Description"
            let date = Date().DayOfWeek(time: day["dt"].doubleValue)
            //TO-DO Deal with optional icon
            let iconID = day["weather"][0]["icon"].string!
            LoadImage(identificator: iconID) { image in
                self.forecasts.append(Forecast(temp: temp, weatherDescription: weatherDescription, date: date, icon: image))
            }
        }
    }
    
    func GetForecastCount() -> Int{
        return forecasts.count
    }
    
    func RefreshData() -> Forecasts?{
        
        var jsonDataForecast = [String:Any]()
        let forecastURL = URL(string: urlString)!
        Fetcher(fromUrl: forecastURL){json in
            jsonDataForecast = json
        }
        return Forecasts(json: jsonDataForecast, urlString: self.urlString)
    }

}

private func LoadImage(identificator: String, onCompletion: (UIImage?) -> Void) {
    let imageURLString = "http://openweathermap.org/img/w/" + identificator + ".png"
    if let imageURL = URL(string: imageURLString) {
        if let imageData = try? Data(contentsOf: imageURL) {
            onCompletion(UIImage(data: imageData))
        }
    }
}