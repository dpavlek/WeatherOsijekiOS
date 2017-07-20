//
//  JsonGetter.swift
//  WeatherOsijek
//
//  Created by COBE Osijek on 19/07/2017.
//  Copyright © 2017 COBE Osijek. All rights reserved.
//

import Foundation
import SwiftyJSON

func getDate(time: Double) -> String {
    
    let todayDate = NSDate(timeIntervalSince1970: time)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    
    return formatter.string(from: todayDate as Date).capitalized
}

struct Weather {
    
    var weather: (main: String, description: String, icon: String)
    var main: (temp: Double, pressure: Double, humidity: Double, temp_min: Double, temp_max: Double)
    var visibility: Int
    var wind: (speed: Double, deg: Double)
    
    init() {
        weather = ("null", "null", "")
        main = (0, 0, 0, 0, 0)
        visibility = 0
        wind = (0, 0)
    }
    
    mutating func parse(url: String) {
        if let url = URL(string: url) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                if json["cod"].intValue == 200 {
                    parser(json: json)
                }
            }
        }
    }
    
    private mutating func parser(json: JSON) {
        for result in json["weather"].arrayValue {
            let weather_main = result["main"].stringValue
            let weather_desc = result["description"].stringValue
            let weather_icon = result["icon"].stringValue
            weather = (weather_main, weather_desc, weather_icon)
        }
        
        let main_temp = json["main"]["temp"].doubleValue
        let main_pressure = json["main"]["pressure"].doubleValue
        let main_humidity = json["main"]["humidity"].doubleValue
        let main_temp_min = json["main"]["temp_min"].doubleValue
        let main_temp_max = json["main"]["temp_max"].doubleValue
        main = (main_temp, main_pressure, main_humidity, main_temp_min, main_temp_max)
        
        visibility = json["visibility"].intValue
        wind = (json["wind"]["speed"].doubleValue, json["wind"]["deg"].doubleValue)
    }
}

struct forecast {
    
    var temp: [Double]
    var weather: [String]
    var date: [String]
    var icon: [String]
    
    init() {
        temp = []
        weather = []
        date = []
        icon = []
    }
    
    mutating func clear() {
        temp = []
        weather = []
        date = []
        icon = []
    }
    
    mutating func parse(url: String) {
        if let url = URL(string: url) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                if json["cod"].intValue == 200 {
                    parser(json: json)
                }
            }
        }
    }
    
    private mutating func parser(json: JSON) {
        for result in json["list"].arrayValue {
            temp.append(result["temp"]["day"].doubleValue - 273.15)
            date.append(getDate(time: result["dt"].doubleValue))
            for element in result["weather"].arrayValue {
                weather.append(element["main"].stringValue)
                icon.append(element["icon"].stringValue)
            }
        }
    }
}

    /*Pokušaj native parsiranja
 
init?(json: [String: Any]) {
        guard let main = json["main"] as? [String: Double],
            let temp = main["temp"],
            let pressure = main["pressure"],
            let humidity = main["humidity"],
            let temp_min = main["temp_min"],
            let temp_max = main["temp_max"],
            let visibility = json["visibility"] as? Int,
            let wind = json["wind"] as? [String: Double],
            let speed = wind["speed"],
            let deg = wind["deg"]
        else {
            return nil
        }
        self.main = (temp, pressure, humidity, temp_min, temp_max)
        self.visibility = visibility
        self.wind = (speed, deg)
    }
}
 
extension Weather {
 
    static func weathers(query: String, url: String, completion: ([Weather]) -> Void) {
        var searchURLComponents = URLComponents(string: url)
        var session = URLSession()
 
        searchURLComponents?.queryItems = [URLQueryItem(name: "q", value: query)]
        session.dataTask(with: (searchURLComponents?.url)!){(_,_,data,_)
            var weathers: [Weather] = []
 
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
 
            }
        }
    }
}*/
