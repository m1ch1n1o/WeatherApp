//
//  BaseService.swift
//  WeatherApp
//
//  Created by Nikoloz Khetsuriani on 2/5/24.
//

import Foundation

class BaseService {
    
    let apiKey = "a6c956ed1b3d6cb807e1f810c865a5e8"
    var components = URLComponents()
    
    required init(path: String) {
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = path
    }
    
    func loadData(latitude: String, longitude: String, completion: @escaping (Result<Data, ServiceError>) -> ()) {
        components.queryItems = [
            "lat": latitude.description,
            "lon": longitude.description,
            "appid": apiKey.description,
            "units": "metric"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = components.url else {
            completion(.failure(.invalidParameters))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.noData))
            }
        }
        task.resume()
    }

}
