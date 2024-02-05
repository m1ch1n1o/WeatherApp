//
//  ForecastHeader.swift
//  WeatherApp
//
//  Created by Nikoloz Khetsuriani on 2/2/24.
//

import UIKit

class ForecastHeader: UITableViewHeaderFooterView {
    
    @IBOutlet var title: UILabel!

    func configure(with date: String) {
        title.text = date
    }
    
}
