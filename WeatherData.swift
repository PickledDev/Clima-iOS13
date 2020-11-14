//
//  WeatherData.swift
//  Clima
//
//  Created by Michael Irwin on 2020/16/03.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
  let name: String
  let main: Main
  let weather: [Weather]
}

struct Main: Codable {
  let temp: Double
}


struct Weather: Codable {
  let description: String
  let id: Int
}
