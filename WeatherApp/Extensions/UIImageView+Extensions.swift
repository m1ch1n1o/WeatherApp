//
//  UIImageView+Extensions.swift
//  WeatherApp
//
//  Created by Nikoloz Khetsuriani on 2/5/24.
//

import UIKit

extension UIImageView {
    
    func loadFromURL(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
    
}
