//
//  CJTableView1_Cell.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/15/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJTableView1_Cell: UITableViewCell {
    
    @IBOutlet var view_BlackLayer: UIView!
    @IBOutlet var label_Title: UILabel!
    
    var prevTouchLocation: CGPoint!
    var index: Int!
    var tableView: CJTableView1!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view_BlackLayer.alpha = 0
        
        // Create shadow for label
        label_Title.layer.shadowColor = UIColor.black.cgColor
        label_Title.layer.shadowRadius = 3.0
        label_Title.layer.shadowOpacity = 1.0
        label_Title.layer.shadowOffset = CGSize(width: 1, height: 2)
        
        self.selectionStyle = .none
        
        let recognizer_Tap = UITapGestureRecognizer(target: self, action: #selector(CJTableView1_Cell.cellTapped(_:)))
        self.addGestureRecognizer(recognizer_Tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func animateBlackLayer() {
        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: 0.2, animations: {
                self.view_BlackLayer.alpha = 1
            })
        })
    }
    
    func hideBlackLayer() {
        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: 0.2, animations: {
                self.view_BlackLayer.alpha = 0
            })
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        prevTouchLocation = (touches.first! ).location(in: self)
        animateBlackLayer()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideBlackLayer()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentTouchLocation = (touches.first! ).location(in: self)
        // Calculate touch displacement
        let displacementX = abs(currentTouchLocation.x - prevTouchLocation.x)
        let displacementY = abs(currentTouchLocation.y - prevTouchLocation.y)
        let displacement = sqrt(displacementX * displacementX + displacementY * displacementY)
        if displacement > 100 {
            hideBlackLayer()
        }
        
    }
    
    @objc func cellTapped(_ recog_Tap: UITapGestureRecognizer) {
        if UserDefaults.standard.bool(forKey: "DarkMode") {
            tableView.view.backgroundColor = UIColor.black
        }
        
        self.hideBlackLayer()
        
        let detailView = self.tableView.storyboard!.instantiateViewController(withIdentifier: "CJTableView2") as! CJTableView2
        detailView.headerCell(self)
        detailView.indexFromPrevView = index
        self.tableView.navigationController?.pushViewController(detailView, animated: true)
    }

}
