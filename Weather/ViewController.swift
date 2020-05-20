//
//  ViewController.swift
//  Weather
//
//  Created by Angela Lim on 4/20/20.
//  Copyright © 2020 Angela Lim. All rights reserved.
//

import UIKit
import CoreLocation
import AudioToolbox
import AVFoundation



class ViewController: UIViewController, CLLocationManagerDelegate, CAAnimationDelegate, UpdateLabelTextDelegate
{
    let defaults = UserDefaults.standard

    func updateLabelText(withText text: String) {
        nameLabel.text = text
        defaults.set(text, forKey: "name")
        
    }
    
       
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    private let apiKey = "2a20a7630451ebb9d0cb5f55b3efd22c"
    var lat = 0.00
    var lon = 0.00
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
 
    
    
    let gradientLayer = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    let dayOfWeek = Singleton.shared["EEEE"]
    var condition = ""
    var sentTemp = 0
    
    
    // colors to be added to the set
    let grayOne = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1).cgColor
    let grayTwo = UIColor(red: 72/255, green: 72/255, blue: 72/255, alpha: 72/255).cgColor
    let grayThree = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00).cgColor
    
    let blueOne = UIColor(red: 0.48, green: 0.76, blue: 1, alpha: 1).cgColor
    let blueTwo = UIColor(red: 72/255, green: 114/255, blue: 184/255, alpha: 1).cgColor
    let blueThree = UIColor(red: 0.22, green: 0.38, blue: 0.66, alpha: 1).cgColor


//plays vibration (can only be felt on a physical device)
    //sends user to the Tips view
    @IBAction func tipsButton(_ sender: Any) {
         AudioServicesPlaySystemSound(SystemSoundID(1007))
        performSegue(withIdentifier: "tipsSegue", sender: self)
        
    }
    //plays vibration (can only be felt on a physical device)
    //Sends user to 5day view
   @IBAction func fiveDayButton(_ sender: UIButton) {
          AudioServicesPlaySystemSound(SystemSoundID(1007))
    performSegue(withIdentifier: "fiveDaysSegue", sender: self)
         }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //saves the name user enters
        let name = defaults.string(forKey: "name")
        if (name != nil){
            self.nameLabel.text = "\(name ?? "Enter your name")"
        }
       
        
        backgroundView.layer.addSublayer(gradientLayer)
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.locationServicesEnabled()){
            getLocation()
            
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    //prepares segue to go to the other three views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
              if segue.identifier == "nameSegue"{
                  let dest = segue.destination as! NameViewController
                  dest.delegate = self
              }
//              else if segue.identifier == "tipsSegue"{
              else if let controller = segue.destination as? TipsViewController{
//                  let updatedTemp = defaults.integer(forKey: "temp")
                controller.recievedTemp = self.sentTemp
                  
                controller.weatherType = self.condition
              }
              else if let fiveDayController = segue.destination as? FiveDayTableViewController{
                fiveDayController.lat = self.lat
                fiveDayController.lon = self.lon
               
            }
           }
   
    //gets location based off of user coordinate
    func getLocation(){
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
        locationManager.requestWhenInUseAuthorization()
        return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    //reverse geocode the coordinates to the city/neighborhood name
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        if !performingReverseGeocoding {
            performingReverseGeocoding = true
            geocoder.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error in
                if let error = error {
                print("*** Reverse Geocoding error: \(error.localizedDescription)")
                    return
                }
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let placemark = placemarks[0]
                        if let city = placemark.subLocality {
                             DispatchQueue.main.async{
                                self.locationLabel.text = "\(city)"

                            }
                        }
                    }
                }
            })
        }
       getWeather()
        
    }
    //location error handler
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("didFailWithError \(error.localizedDescription)") }
   
    

    //func that calls the OpenWeatherMap API and sets the label text and image
    func getWeather(){
        let session = URLSession.shared
         let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial")!
               let dataTask = session.dataTask(with: weatherURL) {
                (data: Data?, response: URLResponse?, error: Error?) in
                if let error = error {
                print("Error:\n\(error)")
                } else {
                if let data = data {
                    //parsing JSON and setting variables to the value to use in labels
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else{return}
                    guard let weather = json["weather"] as? [[String: Any]] else{return}
                 
                    let weatherMain = json["main"] as? [String: Any]
                    self.sentTemp = Int(weatherMain?["temp"] as? Double ?? 0)
                    self.condition = ((weather.first?["main"] as? String)!)
                    let description = (weather.first?["description"] as? String)?.capitalizingFirstLetter()
                    let image = (weather.first?["icon"] as? String)
                    let date = NSDate(timeIntervalSince1970: json["dt"] as! TimeInterval)
                    
                    let day = self.dayOfWeek.string(from: date as Date)
                    let suffix = image?.suffix(1)
                        if(suffix == "n"){
                            DispatchQueue.main.async{
                                self.createGrayGradientView()
                            }
                        }else{
                            DispatchQueue.main.async{
                                self.createBlueGradientView()
                            }
                        }
                    DispatchQueue.main.async{
                        self.conditionLabel.text = "\(description ?? "No Description")"
                        self.temperatureLabel.text = "\(self.sentTemp)"
                        self.conditionImageView.image = UIImage(named: image ?? "01d")
                        self.dayLabel.text = "\(day)"
                        self.defaults.set(self.sentTemp, forKey: "temp")
                    }
                }
                }
                }
                dataTask.resume()
    }
    
    //function to create the gray gradient
    func createGrayGradientView() {
        // overlap the colors and make it 3 sets of colors
        gradientSet.append([grayOne, grayTwo])
        gradientSet.append([grayTwo, grayThree])
        gradientSet.append([grayThree, grayOne])
        
        // set the gradient size to be the entire screen
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = gradientSet[currentGradient]
        gradientLayer.startPoint = CGPoint(x:0, y:0)
        gradientLayer.endPoint = CGPoint(x:1, y:1)
        gradientLayer.drawsAsynchronously = true
        
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        animateGradient()
    }
    
    //function to create the blue gradient
    func createBlueGradientView() {
        // overlap the colors and make it 3 sets of colors
        gradientSet.append([blueOne, blueTwo])
        gradientSet.append([blueTwo, blueThree])
        gradientSet.append([blueThree, blueOne])
        
        // set the gradient size to be the entire screen
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = gradientSet[currentGradient]
        gradientLayer.startPoint = CGPoint(x:0, y:0)
        gradientLayer.endPoint = CGPoint(x:1, y:1)
        gradientLayer.drawsAsynchronously = true
        
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        animateGradient()
    }
    
    //function to animate the gradients where the color will change
    func animateGradient() {
           // cycle through all the colors, feel free to add more to the set
           if currentGradient < gradientSet.count - 1 {
               currentGradient += 1
           } else {
               currentGradient = 0
           }
           
           // animate over 3 seconds
           let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
           gradientChangeAnimation.duration = 3.0
           gradientChangeAnimation.toValue = gradientSet[currentGradient]
           gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
           gradientChangeAnimation.isRemovedOnCompletion = false
           gradientChangeAnimation.delegate = self
           gradientLayer.add(gradientChangeAnimation, forKey: "gradientChangeAnimation")
       }
       
       func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
           
           // if our gradient animation ended animating, restart the animation by changing the color set
           if flag {
               gradientLayer.colors = gradientSet[currentGradient]
               animateGradient()
           }
       }
  
   


    
}


//function to capitalize the description 
extension String{
    func capitalizingFirstLetter() -> String{
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}



