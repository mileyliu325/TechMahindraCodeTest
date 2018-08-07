//
//  DetailViewController.swift
//  TechMahindraCodeTest
//
//  Created by Simeng Liu on 4/8/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import UIKit
import ObjectMapper

class DetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var detailTableView: UITableView!
    var data: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        self.detailTableView.backgroundColor = UIColor.clear
        
        if let weather = data {
            self.cityLabel.text = weather.name!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailId", for: indexPath) as! DetailTableViewCell
        
        if let weather = data {
            switch indexPath.row {
            case 0:
                cell.backgroundColor = UIColor.white
                cell.leftLabel.text = "Summary"
                if let summary = weather.summary{
                    cell.rightLabel.text = "\(summary)"
                }
                
            case 1:
                cell.leftLabel.text = "Min tempature"
                if let temp_min = weather.temp_min {
                    cell.rightLabel.text = "\(kelvinToCelsius(kelvin: temp_min))°C"
                }
            case 2:
                cell.backgroundColor = UIColor.white
                cell.leftLabel.text = "Max tempature"
                if let temp_max = weather.temp_max {
                    cell.rightLabel.text = "\(kelvinToCelsius(kelvin: temp_max))°C"
                }
            case 3:
                cell.leftLabel.text = "Humidity"
                if let humidity = weather.humidity {
                    cell.rightLabel.text = "\(humidity)%"
                }
                
            case 4:
                cell.backgroundColor = UIColor.white
                cell.leftLabel.text = "Pressure"
                if let pressure = weather.pressure {
                    cell.rightLabel?.text = "\(pressure) hPa"
                }
                
            default:
                cell.leftLabel.text = "Wind Speed"
                if let windspeed = weather.windspeed {
                    cell.rightLabel?.text = "\(windspeed) m/s"
                }
            }
        }
        else{
            cell.textLabel?.text = "detail"
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
}
