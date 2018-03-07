//
//  HourCell.swift
//  TipMaster
//
//  Created by Lucas Andrade on 2/15/18.
//  Copyright © 2018 LukeGurgel. All rights reserved.
//

import UIKit

protocol SetHoursProtocol {
    func setHours(cell: HourCell, hours: Float)
}

class HourCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var memberLbl: UILabel!
    @IBOutlet weak var hoursTxt: UITextField!
    var delegate: SetHoursProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hoursTxt.delegate = self
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let hours = textField.text {
            guard let hour = Float(hours) else { return }
            delegate?.setHours(cell: self, hours: hour)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
