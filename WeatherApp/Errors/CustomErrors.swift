//
//  CustomErrors.swift
//  WeatherApp
//
//  Created by Nikoloz Khetsuriani on 2/4/24.
//

import Foundation

enum ServiceError: Error {
    case networkError(String)
    case decodingError(String)
    case noData
    case invalidParameters
}

enum LocationError: Error {
    case locationDenied
}
