//
//  Forecast.swift
//  Weather
//
//  Created by Angela Lim on 5/11/20.
//  Copyright © 2020 Angela Lim. All rights reserved.

//Struct for the 5 day forecast data

import Foundation



struct Forecasts: Codable {
    var list: [Forecast]
}


struct Forecast: Codable{
    var dt: TimeInterval
    var main: Main
    var weather: [Weather]
}

struct Main: Codable{
    var temp: Double
    var tempMin: Double
    var tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Weather: Codable {
    var icon: String
    enum CodingKeys: String, CodingKey {
        case icon
    }
}
