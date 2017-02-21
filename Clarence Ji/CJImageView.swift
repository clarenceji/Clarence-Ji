//
//  CJImageView.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/20/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJImageView: UIImageView {
    override init(image: UIImage?) {
        super.init(image: image)
        self.contentMode = .scaleAspectFill
        self.resize(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func resize(_ image: UIImage!) {
        let screenWidth = UIScreen.main.bounds.width
        let imageRatio = image.size.height / image.size.width
        let imageViewHeight = screenWidth * imageRatio
        
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: imageViewHeight)
    }
}
