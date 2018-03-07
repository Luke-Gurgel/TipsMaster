//
//  GradientView.swift
//  TipMaster
//
//  Created by Lucas Andrade on 2/15/18.
//  Copyright © 2018 LukeGurgel. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 14.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var colorOne: UIColor = UIColor.blue {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var colorTwo: UIColor = UIColor.purple {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        self.setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    func setup() {
        self.layer.cornerRadius = cornerRadius
    }
    
    override func layoutSubviews() {
        let gradient = CAGradientLayer()
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = self.bounds
        gradient.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
