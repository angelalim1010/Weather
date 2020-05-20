//
//  Singleton.swift
//  Weather
//
//  Created by Angela Lim on 5/9/20.
//  Copyright © 2020 Angela Lim. All rights reserved.
//Singleton class to create dateformatter which will change depending on the format provided

import Foundation

class Singleton {
    var formatters = [String: DateFormatter]()

    static let shared = Singleton()
    private init() {}
      
      public subscript(dateFormat: String) -> DateFormatter {
          if let formatter = formatters[dateFormat] {
              return formatter
          }
          
          let newFormatter = DateFormatter()
          newFormatter.dateFormat = dateFormat
          formatters[dateFormat] = newFormatter
          return newFormatter
      }
}
