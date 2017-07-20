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
    func GetDate(time: Double) -> String {
        
        let todayDate = NSDate(timeIntervalSince1970: time)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        return formatter.string(from: todayDate as Date).capitalized
    }
}

struct Weather {
    
    let shortDesc: String
    let longDesc: String
    let weatherIcon: String
    let currentTemp: Double
    let pressure: Double
    let humidity: Double
    let tempMin: Double
    let tempMax: Double
    let visibility: Int
    let windSpeed: Double
    let windDegree: Double
    
    mutating func Parse(url: String) {
        if let url = URL(string: url) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                if json["cod"].intValue == 200 {
                }
            }
        }
    }
    
    init?(json: JSON) {
        for result in json["weather"].arrayValue {
            shortDesc = result["main"].stringValue
            longDesc = result["description"].stringValue
            weatherIcon = result["icon"].stringValue
        }
        
        currentTemp = json["main"]["temp"].doubleValue
        pressure = json["main"]["pressure"].doubleValue
        humidity = json["main"]["humidity"].doubleValue
        tempMin = json["main"]["temp_min"].doubleValue
        tempMax = json["main"]["temp_max"].doubleValue
        
        visibility = json["visibility"].intValue
        windSpeed = json["wind"]["speed"].doubleValue
        windDegree = json["wind"]["deg"].doubleValue
    }
}

struct Forecast {
    
    var temp: Double
    var weather: String
    var date: String
    var icon: String
    
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

extension Weather {
    
    static func weathers(query: String, url: String, completion: ([Weather]) -> Void) {
        var searchURLComponents = URLComponents(string: url)
        var session = URLSession()
        
        searchURLComponents?.queryItems = [URLQueryItem(name: "q", value: query)]
        session.dataTask(with: (searchURLComponents?.url)!){data,_,error in
            var weathers: [Weather] = []
            
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                
            }
        }
    }
}
 
