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
    var fetcher = Fetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastTable.delegate = self
        forecastTable.dataSource = self
        
        let weatherURLString = "http://api.openweathermap.org/data/2.5/weather?q=Osijek,hr&units=metric&appid=913cd011c39c592225373dd9d19f62b3"
        let forecastURLString = "http://api.openweathermap.org/data/2.5/forecast/daily?id=3193935&units=metric&cnt=7&appid=913cd011c39c592225373dd9d19f62b3"
        
        let weatherURL = URL(string: weatherURLString)!
        let forecastURL = URL(string: forecastURLString)!
        
        fetcher.fetch(fromUrl: weatherURL) { [weak self] json in
            self?.weatherObject = Weather(json: json, urlString: weatherURLString)
            self?.showWeatherData()
            
        }
        
        fetcher.fetch(fromUrl: forecastURL) { [weak self] json in
            self?.forecastObject = Forecasts(json: json, urlString: forecastURLString)
            self?.forecastTable.reloadData()
        }
    }
    
    private func showWeatherData() {
        weatherDesc.text = weatherObject?.weatherDesc?.shortDesc
        weatherTemp.text = "Temperature: \(String(weatherObject?.currentTemp ?? -273.15)) °C"
        weatherWind.text = "Wind: \(String(weatherObject?.windSpeed ?? -273.15)) km/h"
        weatherImage.image = weatherObject?.weatherDesc?.weatherIcon
        
    }
    
    @IBAction func reloadWeather(_ sender: UIBarButtonItem) {
        forecastObject?.refreshData { forecast in
            self.forecastObject = forecast
            self.forecastTable.reloadData()
        }
        weatherObject?.refreshData { weather in
            self.weatherObject = weather
            self.showWeatherData()
        }
        forecastTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastObject?.getForecastCount() ?? 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayTableViewCell else {
            fatalError("Cell is not DayTableViewCell")
        }
        
        cell.weatherCellLabel.text = forecastObject?.forecasts[indexPath.row].date
        // TO-DO Temperature. Why optional?
        cell.weatherCellTemp.text = (forecastObject?.forecasts[indexPath.row].temp ?? "nil") + " °C"
        cell.weatherCellImage.image = forecastObject?.forecasts[indexPath.row].icon
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
