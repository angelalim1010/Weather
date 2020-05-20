//
//  TipsViewController.swift
//  Weather
//
//  Created by Angela Lim on 5/7/20.
//  Copyright © 2020 Angela Lim. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class TipsViewController:UIViewController{
 

    
        @IBOutlet weak var clothesLabel: UILabel!
        @IBOutlet weak var umbrellaLabel: UILabel!
                
    //temp and weather condition are coming from the ViewController (passed through segue)
            var recievedTemp = 0
            var weatherType = ""
            
            override func viewDidLoad() {
                   super.viewDidLoad()
                   // Do any additional setup after loading the view.
                getGradient()
                chooseClothes()
                chooseUmbrella()
                
            }
            
            override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
            }
            
        //function to display general clothing you should wear based off the temperature
            func chooseClothes(){
                if recievedTemp < 25 {
                           DispatchQueue.main.async {
                               self.clothesLabel.text = "Winter Jacket"
                           }
                       }
                else if recievedTemp > 25 && recievedTemp < 44 {
                           DispatchQueue.main.async {
                               self.clothesLabel.text = "Light to Medium Jacket"
                           }
                       }
                else if recievedTemp > 44 && recievedTemp < 64 {
                           DispatchQueue.main.async {
                               self.clothesLabel.text = "Thin or Fleece Jacket"
                           }
                      }
                else if recievedTemp > 64 && recievedTemp < 79 {
                           DispatchQueue.main.async {
                               self.clothesLabel.text = "Short Sleeves or Windbreaker"
                           }
                       }
                       else{
                           DispatchQueue.main.async {
                               self.clothesLabel.text = "Short Sleeves and Shorts"
                           }
                       }
            }
    
    //function to change the text of the umbrella label.
            func chooseUmbrella(){
                if weatherType == "ThunderStorm" || weatherType == "Drizzle" || weatherType == "Rain" || weatherType == "Snow" {
                    DispatchQueue.main.async {
                        self.umbrellaLabel.text = "Yes"
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.umbrellaLabel.text = "No"
                    }
                }
            }
    //func to create gradient background
    func getGradient(){
           let colorOne = UIColor(red: 0.01, green: 0.00, blue: 0.14, alpha:1).cgColor
       
           let colorTwo = UIColor(red: 0.01, green: 0.00, blue: 0.14, alpha:0.63).cgColor
           let gradientLayer = CAGradientLayer()
           gradientLayer.frame = self.view.bounds
           gradientLayer.colors = [colorOne,  colorTwo]
           self.view.layer.insertSublayer(gradientLayer, at: 0)
       }
}
