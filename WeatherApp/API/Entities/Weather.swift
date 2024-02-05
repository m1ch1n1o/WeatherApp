//
//  Weather.swift
//  WeatherApp
//
//  Created by Nikoloz Khetsuriani on 1/26/24.
//

import Foundation

struct WeatherResponse: Codable {
    let weather: [WeatherWeather]
    let main: WeatherTemp
    let wind: WeatherWind
    let clouds: WeatherClouds
    let name: String
    let sys: WeatherCountryInfo
}

struct WeatherCountryInfo: Codable {
    let country: String
}

struct WeatherWeather: Codable {
    let main: String
    let icon: String
}

struct WeatherTemp: Codable {
    let temp: Float
    let humidity: Float
    let pressure: Float
}

struct WeatherClouds: Codable {
    let all: Float
}

struct WeatherWind: Codable {
    let speed: Float
    let deg: Float
}

struct WeatherData {
    
    let weather: [WeatherWeather]
    let main: WeatherTemp
    let wind: WeatherWind
    let clouds: WeatherClouds
    let name: String
    let sys: WeatherCountryInfo

    init(weather: [WeatherWeather],
         main: WeatherTemp,
         wind: WeatherWind,
         clouds: WeatherClouds,
         name: String,
         sys: WeatherCountryInfo
    ) {
        self.weather = weather
        self.main = main
        self.wind = wind
        self.clouds = clouds
        self.name = name
        self.sys = sys
    }
    
    func windDirection() -> String {
        return self.wind.windDirection()
    }

}

extension WeatherWind {
  
    func windDirection() -> String {
        let degrees = self.deg
        
        switch degrees {
        case 0..<22.5, 337.5...360:
            return "N"
        case 22.5..<67.5:
            return "NE"
        case 67.5..<112.5:
            return "E"
        case 112.5..<157.5:
            return "SE"
        case 157.5..<202.5:
            return "S"
        case 202.5..<247.5:
            return "SW"
        case 247.5..<292.5:
            return "W"
        case 292.5..<337.5:
            return "NW"
        default:
            return "Unknown"
        }
    }
    
}
