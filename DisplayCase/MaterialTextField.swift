//
//  MaterialTextField.swift
//  DisplayCase
//
//  Created by Kashish Goel on 2016-05-21.
//  Copyright © 2016 Kashish Goel. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {
    
    override func awakeFromNib() {
        
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: shadowColor, green: shadowColor, blue: shadowColor, alpha: 0.1).CGColor
        layer.borderWidth = 1.0
        
    }
    
    //pushes the placeholder text to the right
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    //ensures text is still moved to the right when editing
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }

}
