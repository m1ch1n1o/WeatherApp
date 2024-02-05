//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Nikoloz Khetsuriani on 1/28/24.
//

import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var degrees: UILabel!
    

    func configureCell(with data: ForecastData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: data.dt_txt) {
            dateFormatter.dateFormat = "HH:mm"
            let formattedTime = dateFormatter.string(from: date)
            time.text = formattedTime
        }
        
        desc.text = data.weather.first?.description ?? "No description"
        degrees.text = "\(Int(data.main.temp))°C"
        if let iconURL = URL(string: "https://openweathermap.org/img/w/\(data.weather[0].icon).png") {
            icon.loadFromURL(url: iconURL)
        }
    }
    
}
