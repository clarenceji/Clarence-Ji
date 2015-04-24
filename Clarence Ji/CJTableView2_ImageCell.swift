//
//  CJTableView2_ImageCell.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/20/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJTableView2_ImageCell: UITableViewCell {

    @IBOutlet var image_View: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func resize(image: UIImage!) {
        let screenWidth = UIScreen.mainScreen().bounds.width
        let imageRatio = image.size.height / image.size.width
        let imageViewHeight = screenWidth * imageRatio
        
        self.image_View.image = image
        self.image_View.frame = CGRectMake(0, 0, screenWidth, imageViewHeight)
        self.image_View.bounds = CGRectMake(0, 0, screenWidth, imageViewHeight)
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
