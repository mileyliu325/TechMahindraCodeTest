//
//  WeatherTableViewController.swift
//  TechMahindraCodeTest
//
//  Created by Simeng Liu on 4/8/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage
import ObjectMapper

class WeatherTableViewController: UITableViewController {
    
    var dataSource : NSMutableArray = NSMutableArray()
    var cities:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        dataSource = NSMutableArray()
        cities  = UserDefaults.standard.object(forKey: "city") as! [String]
        for index in 0..<cities.count{
            getWeatherByID(id: cities[index])
        }
        
        createDropdownFresh()
        
        setupTimer()
    }
    
    @objc func refresh(sender:AnyObject) {
        
        dataSource = NSMutableArray()
        
        for index in 0..<cities.count{
            getWeatherByID(id: cities[index])
        }
        
        self.refreshControl?.endRefreshing()
        
    }
    
    // MARK: - refresh once a hour
    
    func setupTimer() {
        var timer = Timer.scheduledTimer(timeInterval: 3600,
                                         target: self,
                                         selector: #selector(refresh(sender:)),
                                         userInfo: nil,
                                         repeats: true)
    }
    

    // MARK: - drop down to fresh
    
  
    func createDropdownFresh() -> Void {
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action:#selector(refresh), for: UIControlEvents.valueChanged)
        
        self.tableView.addSubview(refreshControl!)
    }
    
    // MARK: - Table view delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
        
        var num =  (UserDefaults.standard.object(forKey: "city") as! [String]).count
        
        if self.dataSource.count == num{
            
            let weather = self.dataSource[indexPath.row] as! WeatherModel
            cell.cityLabel.text = weather.name
            if let temp = weather.temp{
                cell.tempLabel.text = "\(kelvinToCelsius(kelvin: temp))°C "
            }
            if let summary = weather.summary {
                cell.weatherLabel.text = summary
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let weather = self.dataSource[indexPath.row] as! WeatherModel
        self.performSegue(withIdentifier: "weatherDetail", sender:weather )
    }
    
    
    // MARK: - Networking
    
    func getWeatherByID(id: String) {
        
        dataSource = NSMutableArray()
        
        SVProgressHUD.show()
        
        let requestUrl = "http://api.openweathermap.org/data/2.5/weather?id=\(id)&units=metri c&APPID=\(APIKey)"
        let safeURL = requestUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request(safeURL!)
            .validate()
            .responseJSON {response in
                switch response.result{
                case .success(let value):
                    let weatherData = Mapper<WeatherModel>().map(JSONObject:value)
                    self.dataSource.add(weatherData as Any)
                    self.tableView.reloadData()
                    
                    SVProgressHUD.dismiss()
                    
                case .failure(let error):
                    
                    print("Request Error:\(error)")
                    
                    SVProgressHUD.dismiss()
                    
                    let alert =  UIAlertController (title: "Alert", message:"Request Time out, please Check your Network", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }//[End of switch]
        }//[End of response]
    }//[End of get data result]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "weatherDetail" {
            
            let nextViewController = segue.destination as! DetailViewController
            
            nextViewController.data = sender as! WeatherModel
        }
    }
}
