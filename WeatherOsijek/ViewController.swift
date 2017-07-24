//
//  ViewController.swift
//  WeatherOsijek
//
//  Created by COBE Osijek on 18/07/2017.
//  Copyright © 2017 COBE Osijek. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDesc: UILabel!
    @IBOutlet weak var weatherTemp: UILabel!
    @IBOutlet weak var weatherWind: UILabel!
    @IBOutlet weak var forecastTable: UITableView!
    
    var forecastObject: Forecasts?
    var weatherObject: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastTable.delegate = self
        forecastTable.dataSource = self
        
        let weatherURLString = "http://api.openweathermap.org/data/2.5/weather?q=Osijek,hr&units=metric&appid=913cd011c39c592225373dd9d19f62b3"
        let forecastURLString = "http://api.openweathermap.org/data/2.5/forecast/daily?id=3193935&units=metric&cnt=7&appid=913cd011c39c592225373dd9d19f62b3"
        
        let weatherURL = URL(string: weatherURLString)!
        let forecastURL = URL(string: forecastURLString)!
        
        var jsonDataWeather = [String: Any]()
        var jsonDataForecast = [String: Any]()
        
        Fetcher(fromUrl: forecastURL) { json in
            jsonDataForecast = json
        }
        
        var forecastObject = Forecasts(json: jsonDataWeather, urlString: forecastURLString)
        
        Fetcher(fromUrl: weatherURL) { json in
            jsonDataWeather = json
        }
        var weatherObject = Weather(json: jsonDataWeather, urlString: weatherURLString)
        
        weatherDesc.text = weatherObject?.weatherDesc?.shortDesc
        weatherTemp.text = "Temperature: \(String(describing: weatherObject?.currentTemp)) °C"
        weatherWind.text = "Wind speed: \(String(describing: weatherObject?.windSpeed)) km/h"
        weatherImage.image = weatherObject?.weatherDesc?.weatherIcon
    }
    
    @IBAction func reloadWeather(_ sender: UIBarButtonItem) {
        forecastObject = forecastObject?.RefreshData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastObject?.GetForecastCount() ?? 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayTableViewCell else {
            fatalError("Cell is not DayTableViewCell")
        }
        
        cell.weatherCellLabel.text = forecastObject?.forecasts[indexPath.row].weatherDescription
        cell.weatherCellTemp.text = String(describing: forecastObject?.forecasts[indexPath.row].temp) + " °C"
        cell.weatherCellImage.image = forecastObject?.forecasts[indexPath.row].icon
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
