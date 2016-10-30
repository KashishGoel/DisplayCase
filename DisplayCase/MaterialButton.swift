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
        layer.shadowColor = UIColor(red: shadowColor, green: shadowColor, blue: shadowColor, alpha: 0.5).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }

}
