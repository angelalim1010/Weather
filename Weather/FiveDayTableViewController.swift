//
//  FiveDayTableViewController.swift
//  Weather
//
//  Created by Angela Lim on 5/9/20.
//  Copyright © 2020 Angela Lim. All rights reserved.
//

import UIKit

class FiveDayTableViewController: UITableViewController {
    //create instance of Singleton class
    var forecasts = [Forecast]()
    let dayOfWeek = Singleton.shared["MMM d"]
    let timeOfDay = Singleton.shared["h:mm a"]


    
    private let apiKey = "2a20a7630451ebb9d0cb5f55b3efd22c"
    
    //lat and lon will be given through segue from ViewController
    var lat = 0.00
    var lon = 0.00

    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let cellNib = UINib(nibName: "ForecastWeatherCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ForecastCell")
    }
    
    //function to get the 5 day forecast from OpenWeatherMap
    func getWeather() {
        let session = URLSession.shared
        let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial")!
        let dataTask = session.dataTask(with: weatherURL){ (data, response, err) in
            if let err = err {print(err)}
            guard let data = data else{return}
            do{
                self.parse(json: data)
                }
            }
        dataTask.resume()
    }
        
    //func to parse the JSON data
    func parse(json: Data){
        let decoder = JSONDecoder()
        if let jsonForecasts = try? decoder.decode(Forecasts.self, from: json){
            forecasts = jsonForecasts.list
            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return forecasts.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ForecastCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ForecastWeatherCell
        let forecast = forecasts[indexPath.row]
        
        //get the date from the time taken from the parsed JSON
        let date = NSDate(timeIntervalSince1970: forecast.dt )
        //get the temp and image from the parsed JSON
        let highTemp = Int(forecast.main.tempMax)
        let lowTemp = Int(forecast.main.tempMin)
        let forecastImg = forecast.weather[0].icon
        //set the label text
        cell.dayLabel.text = dayOfWeek.string(from: date as Date)
        cell.timeLabel.text = timeOfDay.string(from: date as Date)
        cell.highTempLabel.text = "\(highTemp)"
        cell.lowTempLabel.text = "\(lowTemp)"
        cell.forecastImage.image = UIImage(named: forecastImg)


        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "5 Day Forecast"
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
