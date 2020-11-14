//
//  WeatherManager.swift
//  Clima
//
//  Created by Michael Irwin on 2020/16/03.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
  func didFailWithError(error: Error)
}

struct WeatherManager {
  let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=92fa2926234f18171f58a8daba3e7687&units=metric"
  
  var delegate: WeatherManagerDelegate?
  
  func fetchWeather(cityName: String) {
    // need to replace spaces in city name with %20
    var city = cityName
    city = city.replacingOccurrences(of: " ", with: "%20")
    
    let urlString = "\(weatherURL)&q=\(city)"
    performRequest(with: urlString)
  }
  
  func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
    performRequest(with: urlString)
  }
  
  func performRequest(with urlString: String) {
    // 1. create a URL
    if let url = URL(string: urlString) {
      // 2. Create a URL Session
      let session = URLSession(configuration: .default)
      
      // 3. Give the session a task
      // what I started with -> let task = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
      
      // Using a closure
      let task = session.dataTask(with: url) { (data, response, error) in
        if error != nil {
          self.delegate?.didFailWithError(error: error!)
          return
        }
        
        if let safeData = data {
          // original
          //          let dataString = String(data: safeData, encoding: .utf8)
          //          print(dataString!)
          
          // json response formatter to convert to a swift object
          if let weather = self.parseJSON(safeData) {
            self.delegate?.didUpdateWeather(self, weather: weather)
          }
        }
      }
      
      // 4. Start the task
      task.resume()
    }
  }
  
  // what we used with the original task
  //  func handle(data: Data?, response: URLResponse?, error: Error?) {
  //    if error != nil {
  //      print(error!)
  //      return
  //    }
  //
  //    if let safeData = data {
  //      let dataString = String(data: safeData, encoding: .utf8)
  //      print(dataString!)
  //    }
  //  }
  
  func parseJSON(_ weatherData: Data) -> WeatherModel? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
      let id = decodedData.weather[0].id
      let temp = decodedData.main.temp
      let name = decodedData.name
      
      let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
      return weather
    } catch {
      delegate?.didFailWithError(error: error)
      return nil
    }
  }
}
