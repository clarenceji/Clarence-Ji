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
    
    func resize(_ image: UIImage!) {
        let screenWidth = UIScreen.main.bounds.width
        let imageRatio = image.size.height / image.size.width
        let imageViewHeight = screenWidth * imageRatio
        
        self.image_View.image = image
        self.image_View.frame = CGRect(x: 0, y: 0, width: screenWidth, height: imageViewHeight)
        self.image_View.bounds = CGRect(x: 0, y: 0, width: screenWidth, height: imageViewHeight)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
