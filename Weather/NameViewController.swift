//
//  NameViewController.swift
//  Weather
//
//  Created by Angela Lim on 5/10/20.
//  Copyright © 2020 Angela Lim. All rights reserved.
//

import UIKit

protocol UpdateLabelTextDelegate: class {
    func updateLabelText(withText text: String)
}

class NameViewController: UIViewController{
    
    @IBOutlet weak var nameTextView: UITextField!
    
    //the set name will be sent back to ViewController through delegate
   weak var delegate: UpdateLabelTextDelegate?
    
    @IBAction func done(){
        delegate?.updateLabelText(withText: nameTextView.text!)
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func cancel(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGradient()
    }
    
    //function to create the gradient background
    func getGradient(){
        let colorOne = UIColor(red: 0.01, green: 0.00, blue: 0.14, alpha:1).cgColor
        let colorTwo = UIColor(red: 0.42, green: 0.64, blue: 1, alpha: 0.93).cgColor
        let colorThree = UIColor(red: 0.01, green: 0.00, blue: 0.14, alpha:0.63).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [colorOne, colorTwo, colorThree]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
