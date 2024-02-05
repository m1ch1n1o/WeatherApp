//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nikoloz Khetsuriani on 1/26/24.
//

import UIKit
import CoreLocation

class TodayVC: UIViewController {
    
    let locationManager = CLLocationManager()
    var longtitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    
    let weatherService = WeatherService()
    
    
    @IBOutlet weak var loader: UIActivityIndicatorView!        
    
    @IBOutlet weak var topSV: UIStackView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var topLocation: UILabel!
    @IBOutlet weak var topTemp: UILabel!
    
    @IBOutlet weak var separatorLine: UIView!
    
    @IBOutlet weak var cloudsIcon: UIImageView!
    @IBOutlet weak var cloudsLabel: UILabel!
    
    @IBOutlet weak var rainIcon: UIImageView!
    @IBOutlet weak var rainLabel: UILabel!
    
    @IBOutlet weak var pressureIcon: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var windIcon: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var directionIcon: UIImageView!
    @IBOutlet weak var directionLabel: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    private let errorView = ErrorView()
    
    private var loadedWeatherData: WeatherData? {
        didSet {
            updateShareButtonState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateShareButtonState()
        mainView.isHidden = true
        
        setupLocationManager()
        checkAuthorization()
    }
    
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func checkAuthorization() {
        let alertController = UIAlertController(
            title: "Permission Denied",
            message: "Please go to Settings and turn on location permissions",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(
            title: "Settings",
            style: .default
        ){ (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(
                    settingsUrl,
                    completionHandler: { (success) in }
                )
            }
        }
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .default,
            handler: nil
        )
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case .notDetermined, .restricted:
            break
        case .denied:
            self.showLocationErrorView(message: "Please go to Settings and turn on location permission")
            self.present(alertController, animated: true, completion: nil)
        @unknown default: break
        }
    }
    
    func loadSuccessfully(_ weatherData: (WeatherData)) {
        if let iconURL = URL(string: "https://openweathermap.org/img/w/\(weatherData.weather[0].icon).png") {
            self.topImageView.loadFromURL(url: iconURL)
        }
        self.topLocation.text = "\(weatherData.name), \(weatherData.sys.country)"
        self.topTemp.text = "\(Int(weatherData.main.temp))°C | \(weatherData.weather[0].main)"
        
        self.cloudsIcon.image = UIImage(named: "raining")
        self.cloudsIcon.tintColor = .systemOrange
        self.cloudsLabel.text = "\(String(Int(weatherData.clouds.all))) %"
        
        self.rainIcon.image = UIImage(named: "drop")
        self.rainIcon.tintColor = .systemOrange
        self.rainLabel.text = "\(String(Int(weatherData.main.humidity))) mm"
        
        self.pressureIcon.image = UIImage(named: "celsius")
        self.pressureIcon.tintColor = .systemOrange
        self.pressureLabel.text = "\(String(weatherData.main.pressure)) hPa"
        
        self.windIcon.image = UIImage(named: "wind")
        self.windIcon.tintColor = .systemOrange
        self.windLabel.text = "\(String(weatherData.wind.speed)) km/h"
        
        self.directionIcon.image = UIImage(named: "compass")
        self.directionIcon.tintColor = .systemOrange
        self.directionLabel.text = String(weatherData.wind.windDirection())
        
        self.mainView.isHidden = false
    }
    
    func showLocationErrorView(message: String) {
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isUserInteractionEnabled = false
        }
        
        errorView.delegate = self
        errorView.configureLocationError(with: message)
        errorView.frame = self.view.bounds
        self.view.addSubview(errorView)
    }
    
    func showServiceErrorView(message: String) {
        errorView.delegate = self
        errorView.configureServiceError(with: message)
        errorView.frame = self.view.bounds
        self.view.addSubview(errorView)
    }
    
    func hideError() {
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isUserInteractionEnabled = true
        }
        errorView.removeFromSuperview()
    }
    
    @IBAction func reload() {
        setupLocationManager()
    }
    
    @IBAction func share() {
        guard loadedWeatherData != nil else { return }
        
        let curLoc = "Current weather in \(loadedWeatherData!.name): "
        let curTemp = "\(Int((loadedWeatherData!.main.temp)))°C, "
        let curWeatherState = "\(loadedWeatherData!.weather[0].main)"
        
        let shareText = "\(curLoc)\(curTemp)\(curWeatherState)"
        
        let activityViewController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(
                x: self.view.bounds.midX,
                y: self.view.bounds.midY,
                width: 0,
                height: 0
            )
            
            popoverPresentationController.permittedArrowDirections = []
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    func updateShareButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = loadedWeatherData != nil
    }
    
}


extension TodayVC: CLLocationManagerDelegate {
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        
        self.hideError()
        self.mainView.isHidden = true
        loadedWeatherData = nil
        
        loader.startAnimating()
        
        weatherService.loadWeather(
            latitude: latitude,
            longitude: longitude
        )
        { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async { [self] in
                self.loader.stopAnimating()
                
                switch result {
                case .success(let weatherData):
                    self.loadedWeatherData = weatherData
                    self.loadSuccessfully(weatherData)
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
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        checkAuthorization()
    }
    
}

extension TodayVC: ErrorViewDelegate {
    func retryButtonTapped() {
        setupLocationManager()
    }
}
