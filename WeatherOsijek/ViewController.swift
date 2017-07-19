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
    
    var forecastObject = forecast()
    var weatherObject = Weather()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastTable.delegate = self
        forecastTable.dataSource = self
        
        refreshData()
    }
    
    func refreshData() {
        
        forecastObject.clear()
        // Do any additional setup after loading the view, typically from a nib.
        let parsingURL = "http://api.openweathermap.org/data/2.5/weather?q=Osijek,hr&units=metric&appid=913cd011c39c592225373dd9d19f62b3"
        weatherObject.parse(url: parsingURL)
        
        weatherDesc.text = weatherObject.weather.description.capitalized
        weatherTemp.text = "Temperature: \(weatherObject.main.temp) °C"
        weatherWind.text = "Wind speed: \(weatherObject.wind.speed) km/h"
        
        DispatchQueue.global().async {
            if let weatherImage = self.loadImage(identificator: self.weatherObject.weather.icon) {
                DispatchQueue.main.async {
                    self.weatherImage.image = weatherImage
                }
            }
        }
        
        let forecastURL = "http://api.openweathermap.org/data/2.5/forecast/daily?id=3193935&cnt=7&appid=913cd011c39c592225373dd9d19f62b3"
        forecastObject.parse(url: forecastURL)
        
        print(forecastObject.date[0])
        
        forecastTable.reloadData()
        
    }
    
    @IBAction func reloadWeather(_ sender: UIBarButtonItem) {
        refreshData()
    }
    
    func loadImage(identificator: String) -> UIImage? {
        let imageURLString = "http://openweathermap.org/img/w/" + identificator + ".png"
        if let imageURL = URL(string: imageURLString) {
            if let imageData = try? Data(contentsOf: imageURL) {
                return UIImage(data: imageData)
            }
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastObject.date.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayTableViewCell else {
            fatalError("Cell is not DayTableViewCell")
        }
        cell.weatherCellLabel.text = forecastObject.date[indexPath.row]
        cell.weatherCellTemp.text = String(forecastObject.temp[indexPath.row]) + " °C"
        DispatchQueue.global().async {
            if let weatherImage = self.loadImage(identificator: self.forecastObject.icon[indexPath.row]) {
                DispatchQueue.main.async {
                    cell.weatherCellImage.image = weatherImage
                }
            }
        }
        // cell.planetImage?.image = UIImage(data: planets[indexPath.row].image!)
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
