//
//  WeatherModel.swift
//  Clima
//
//  Created by Michael Irwin on 2020/16/03.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
  let conditionId: Int
  let cityName: String
  let temperature: Double
  
  // this is a computed property
  var conditionName: String {
    switch conditionId {
    case 200...232:
      return "cloud.bolt"
    case 300...321:
      return "cloud.drizzle"
    case 500...531:
      return "cloud.rain"
    case 600...632:
      return "cloud.snow"
    case 701...781:
      return "sun.max"
    case 801...804:
      return "cloud.bolt"
    default:
      return "cloud"
    }
  }
  
  var temperatureString: String {
    return String(format: "%.1f", temperature)
  }
}

