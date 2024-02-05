//
//  BaseReusableView.swift
//  WeatherApp
//
//  Created by Nikoloz Khetsuriani on 2/4/24.
//

import UIKit

class BaseReusableView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    var nibName: String {
        return String(describing: Self.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    func commonInit() {
        let bundle = Bundle(for: Self.self)
        bundle.loadNibNamed(nibName, owner: self, options: nil)
        
        guard let contentView = contentView
        else { fatalError("contentView not set! ") }
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(contentView)
    }
    
    func setup() { }
    
}
