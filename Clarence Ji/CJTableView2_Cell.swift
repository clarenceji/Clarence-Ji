//
//  CJTableView2_Cell.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/19/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJTableView2_Cell: UITableViewCell {

    @IBOutlet var label_Main: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label_Main.textContainerInset = UIEdgeInsetsMake(15, 7, 15, 7)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}