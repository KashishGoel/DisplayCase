//
//  MaterialButton.swift
//  DisplayCase
//
//  Created by Kashish Goel on 2016-05-21.
//  Copyright © 2016 Kashish Goel. All rights reserved.
//


import UIKit

class MaterialButton: UIButton {
    override func awakeFromNib() {
        layer.cornerRadius = 4.0
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8
        layer.shadowColor = UIColor(red: shadowColor, green: shadowColor, blue: 0.0, alpha: 0.5).CGColor
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }

}
