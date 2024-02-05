//
//  ForecastVC.swift
//  WeatherApp
//
//  Created by Nikoloz Khetsuriani on 1/28/24.
//

import UIKit
import CoreLocation


class ForecastVC: UIViewController {
    
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    var forecastData: [ForecastData] = []
    let forecastService = ForecastService()
    
    let locationManager = CLLocationManager()
    var longtitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    
    var groupedForecastData: [String: [ForecastData]] = [:]
    
    private let errorView = ErrorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        configureTableView()
    }
    
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isHidden = true
        
        let nib = UINib(nibName: "ForecastCell", bundle: nil)
        tableView.register(
            nib,
            forCellReuseIdentifier: "ForecastCell"
        )
        
        let headerNib = UINib(nibName: "ForecastHeader", bundle: nil)
        tableView.register(
            headerNib,
            forHeaderFooterViewReuseIdentifier: "ForecastHeader"
        )
    }
    
    @IBAction func reload() {
        setupLocationManager()
    }
    
    func parseForecastData() {
        groupedForecastData.removeAll()
        
        for forecast in forecastData {
            if let dayName = dayOfWeek(from: forecast.dt_txt) {
                if var existingForecasts = groupedForecastData[dayName] {
                    existingForecasts.append(forecast)
                    groupedForecastData[dayName] = existingForecasts
                } else {
                    groupedForecastData[dayName] = [forecast]
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func showServiceErrorView(message: String) {
        errorView.delegate = self
        errorView.configureServiceError(with: message)
        errorView.frame = self.view.bounds
        self.view.addSubview(errorView)
    }
    
    func hideError() {
        errorView.removeFromSuperview()
    }

    func dayOfWeek(from date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: date) else {
            return nil
        }
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        return dayFormatter.string(from: date)
    }
    
}


extension ForecastVC: CLLocationManagerDelegate {
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }
        
        locationManager.stopUpdatingLocation()
        
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        
        self.hideError()
        self.tableView.isHidden = true
        
        loader.startAnimating()
        
        forecastService.loadForecast(
            latitude: latitude,
            longitude: longitude
        )
        { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async { [self] in
                self.loader.stopAnimating()
                self.tableView.isHidden = false
                
                switch result {
                case .success(let forecastData):
                    self.forecastData = forecastData
                    self.parseForecastData()
                case .failure(let error):
                    switch error {
                    case .networkError(let errorMessage):
                        self.showServiceErrorView(message: "Network Error: \(errorMessage)")
                    case .decodingError(let errorMessage):
                        self.showServiceErrorView(message: "Decoding Error: \(errorMessage)")
                    case .noData:
                        self.showServiceErrorView(message: "No Data Error")
                    case .invalidParameters:
                        self.showServiceErrorView(message: "Invalid Parameters Error")
                    }
                }
            }
        }
    }
    
}


extension ForecastVC: ErrorViewDelegate {
    func retryButtonTapped() {
        setupLocationManager()
    }
}


extension ForecastVC: UITableViewDelegate, UITableViewDataSource {
    
    private func sortedDays() -> [String] {
        let weekDays = [
            "Monday", "Tuesday", "Wednesday",
            "Thursday", "Friday", "Saturday", "Sunday"
        ]
        
        let sortedDays = groupedForecastData.keys.sorted { (day1, day2) -> Bool in
            if let index1 = weekDays.firstIndex(of: day1), let index2 = weekDays.firstIndex(of: day2) {
                return index1 < index2
            }
            return false
        }
        
        return sortedDays
    }
    
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return sortedDays().count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        let dayKey = sortedDays()[section]
        return groupedForecastData[dayKey]?.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ForecastCell",
            for: indexPath
        ) as? ForecastCell else {
            return UITableViewCell()
        }
        
        let dayKey = sortedDays()[indexPath.section]
        if let forecasts = groupedForecastData[dayKey] {
            
            let forecast = forecasts[indexPath.row]
            cell.configureCell(with: forecast)
        }
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "ForecastHeader"
        ) as? ForecastHeader else {
            return nil
        }
        
        let dayKey = sortedDays()[section]
        header.configure(with: dayKey)
        
        return header
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 44.0
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 80
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
