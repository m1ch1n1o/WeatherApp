//
//  Forecast.swift
//  WeatherApp
//
//  Created by Nikoloz Khetsuriani on 1/27/24.
//

import Foundation
                    
struct ForecastResponse: Codable {
    let list: [ForecastData]
}

struct ForecastData: Codable {
    let main: ForecastTemp
    let weather: [ForecastWeather]
    let dt_txt: String  
}

struct ForecastTemp: Codable {
    let temp: Float
}

struct ForecastWeather: Codable {
    let main: String
    let description: String
    let icon: String
}
