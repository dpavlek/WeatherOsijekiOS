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
    
    let viewModel = ViewModel(fetcher: Fetcher())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastTable.dataSource = self
        forecastTable.delegate = self
        
        viewModel.fetchWeather { [weak self] _ in
            self?.showWeatherData()
        }
        
        viewModel.fetchForecast { [weak self] _ in
            self?.forecastTable.reloadData()
        }
        
    }
    
    private func showWeatherData() {
        let weatherInfo = viewModel.showWeatherData()
        weatherDesc.text = weatherInfo["WeatherDescription"] as? String
        weatherTemp.text = weatherInfo["Temperature"] as? String
        weatherWind.text = weatherInfo["WindSpeed"] as? String
        weatherImage.image = weatherInfo["WeatherIcon"] as? UIImage
    }
    
    @IBAction func reloadWeather(_ sender: UIBarButtonItem) {
        viewModel.refreshWeather { [weak self] _ in
            self?.showWeatherData()
        }
        viewModel.refreshForecasts { [weak self] _ in
            self?.forecastTable.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getForecastCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayTableViewCell else {
            fatalError("Cell is not DayTableViewCell")
        }
        
        let currentForecast = viewModel.getForecast(forIndex: indexPath.row)
        
        cell.weatherCellLabel.text = currentForecast?.weatherDescription
        cell.weatherCellTemp.text = (currentForecast?.temp ?? "nil") + " °C"
        cell.weatherCellImage.image = currentForecast?.icon
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
