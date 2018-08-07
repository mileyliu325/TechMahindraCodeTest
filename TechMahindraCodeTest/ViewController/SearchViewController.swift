//
//  SearchViewController.swift
//  TechMahindraCodeTest
//
//  Created by Simeng Liu on 4/8/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD

class SearchViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var searchTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var dataSource : NSMutableArray = NSMutableArray()
    var searched : NSMutableArray = NSMutableArray()
    
    var isSearch = false//default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show(withStatus: "Loading cities information")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.searchBar.showsCancelButton = true
        self.searchBar.delegate = self
        
        self.searchTable.delegate = self
        self.searchTable.dataSource = self
        
        self.searchTable.backgroundColor = UIColor.clear
        
        let delayTime = DispatchTime.now() + 1
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.readCityFile()
        }
        
    }
    
    func readCityFile(){
        
        if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                if let jsonArray = jsonResult as? NSArray {
                    
                    if jsonArray.count == 0 {
                        
                        SVProgressHUD.dismiss()
                        print("Load city info error")
                        
                        return
                    }
                    
                    for index in stride(from: 0, to: jsonArray.count, by: 1) {
                        
                        let city = Mapper<CityModel>().map(JSONObject: jsonArray[index])
                        self.dataSource.add(city)
                        
                    }
                    
                    SVProgressHUD.dismiss()
                    
                }
            } catch {
                
                print("read file erro:\(error)")
                
                let alert =  UIAlertController (title: "Alert", message:"Cannot laod cities", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: UITableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searched.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")
        let searched = self.searched[indexPath.row] as! CityModel
        cell?.textLabel?.text = "\(searched.name!), \(searched.country!)"
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        let searched = self.searched[indexPath.row] as! CityModel
        let cityId = "\(searched.id!)"

        var cities  = UserDefaults.standard.object(forKey: "city") as! [String]
        cities.append(cityId)
        
        UserDefaults.standard.set(cities, forKey: "city")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: UISearchBarDelegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTable.backgroundColor = UIColor.clear
        // empty
        if searchText == "" {
            self.searched = []
        } else {
            
            // search
            self.searched = []
            
            for city in self.dataSource {
                
                let searchedCity =  city as! CityModel
                
                if (searchedCity.name?.lowercased().hasPrefix(searchText.lowercased()))!{
                    self.searched.add(searchedCity)
                    
                }
            }
        }
        self.searchTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
