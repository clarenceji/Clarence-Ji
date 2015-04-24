//
//  CJProjectDetailPopupView_Cell.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/22/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJProjectDetailPopupView_Cell: UITableViewCell {

    @IBOutlet var label_Key: UILabel!
    @IBOutlet var label_Value: UILabel!
    @IBOutlet var label_Key_ConstraintWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
