//
//  ForecastService.swift
//  WeatherApp
//
//  Created by Nikoloz Khetsuriani on 1/27/24.
//

import Foundation

class ForecastService: BaseService {

    required init(path: String = "/data/2.5/forecast" ) {
        super.init(path: path)
    }
    
    func loadForecast(
        latitude: String,
        longitude: String,
        completion: @escaping (Result<[ForecastData], ServiceError>) -> ()
    ) {
        loadData(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(ForecastResponse.self, from: data)
                    completion(.success(result.list))
                } catch {
                    completion(.failure(.decodingError(error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
