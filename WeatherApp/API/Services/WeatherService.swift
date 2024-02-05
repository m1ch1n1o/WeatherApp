//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Nikoloz Khetsuriani on 1/27/24.
//

import Foundation

class WeatherService: BaseService {
    
    required init(path: String = "/data/2.5/weather" ) {
        super.init(path: path)
    }
    
    func loadWeather(
        latitude: String,
        longitude: String,
        completion: @escaping (Result<WeatherData, ServiceError>) -> ()
    ) {
        loadData(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(WeatherResponse.self, from: data)
                    let weatherData = WeatherData(weather: result.weather, main: result.main, wind: result.wind, clouds: result.clouds, name: result.name, sys: result.sys)
                    completion(.success(weatherData))
                } catch {
                    completion(.failure(.decodingError(error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
