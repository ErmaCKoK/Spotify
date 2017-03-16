//
//  GradientView.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 11/3/16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    private var gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.gradientLayer.frame = self.bounds
        self.gradientLayer.shouldRasterize = true
        self.gradientLayer.rasterizationScale = UIScreen.main.scale
        self.gradientLayer.colors = [UIColor.clear.cgColor, UIColor(white: 0.0, alpha: 1.0).cgColor]
        self.gradientLayer.locations = [NSNumber(value: 0.40), NSNumber(value: 1.0)]
        
        self.layer.mask = self.gradientLayer
    }
}

