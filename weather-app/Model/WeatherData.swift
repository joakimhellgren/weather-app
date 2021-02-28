//
//  WeatherData.swift
//  weather-app
//
//  Created by Joakim Hellgren on 2021-02-28.
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
