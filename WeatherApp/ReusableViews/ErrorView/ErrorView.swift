//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Nikoloz Khetsuriani on 2/4/24.
//

import UIKit

class ErrorView: BaseReusableView {
    
    weak var delegate: ErrorViewDelegate?
    
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var reloadButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    
    override func setup() {
        super.setup()
        configureReloadButtonDesign()
        configureSettingsButtonDesign()
    }
    
    func configureReloadButtonDesign() {
        reloadButton.layer.cornerRadius = 4
    }
    
    func configureServiceError(with message: String) {
        settingsButton.isHidden = true
        reloadButton.isHidden = false
        errorLabel.text = message
    }
    
    @IBAction func didClickReloadButton() {
        delegate?.retryButtonTapped()
    }
    
    
    func configureSettingsButtonDesign() {
        reloadButton.isHidden = true
        settingsButton.isHidden = false
        settingsButton.layer.cornerRadius = 4
    }
    
    func configureLocationError(with message: String) {
        errorLabel.text = message
    }  
    
    @IBAction func didClickSettingsButton() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(
                settingsURL,
                options: [:],
                completionHandler: nil
            )
        }
    }
}

protocol ErrorViewDelegate: AnyObject {
    func retryButtonTapped()
}
