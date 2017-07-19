//
//  ViewController.swift
//  WeatherOsijek
//
//  Created by COBE Osijek on 18/07/2017.
//  Copyright © 2017 COBE Osijek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDesc: UILabel!
    @IBOutlet weak var weatherTemp: UILabel!
    @IBOutlet weak var weatherWind: UILabel!
    @IBOutlet weak var forecastTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let parsingURL = "http://api.openweathermap.org/data/2.5/weather?q=Osijek,hr&units=metric&appid=913cd011c39c592225373dd9d19f62b3"
        var weatherObject = Weather()
        weatherObject.parse(url: parsingURL)
        
        weatherDesc.text = weatherObject.weather.description.capitalized
        weatherTemp.text = "Temperature: \(weatherObject.main.temp) °C"
        weatherWind.text = "Wind speed: \(weatherObject.wind.speed) km/h"
        
        let imageURLString = "http://openweathermap.org/img/w/" + weatherObject.weather.icon + ".png"
        if let imageURL = URL(string: imageURLString){
            if let imageData = try? Data(contentsOf: imageURL){
                weatherImage.image = UIImage(data: imageData)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
