//
//  SoftButton.swift
//  TipMaster
//
//  Created by Lucas Andrade on 2/15/18.
//  Copyright © 2018 LukeGurgel. All rights reserved.
//

import UIKit

@IBDesignable
class SoftButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
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
    
}
