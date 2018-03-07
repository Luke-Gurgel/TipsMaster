//
//  TipsCell.swift
//  TipMaster
//
//  Created by Lucas Andrade on 2/15/18.
//  Copyright © 2018 LukeGurgel. All rights reserved.
//

import UIKit

class TipsCell: UICollectionViewCell {
    
    @IBOutlet weak var memberLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var tipsLbl: UILabel!
    
    func setup(member: Member) {
        memberLbl.text = member.name
        hoursLbl.text = String(member.hours)
        tipsLbl.text = "$\(String(member.tips))"
    }
    
}
