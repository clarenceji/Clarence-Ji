//
//  CJTableView1.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/15/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJTableView1: UITableViewController {

    var nightMode = UserDefaults.standard.bool(forKey: "DarkMode")
    let rowHeight = (UIScreen.main.bounds.height - 20) / 5
    let screenWidth = UIScreen.main.bounds.width
    var cellArray: [AnyObject?] = [nil, nil, nil, nil, nil]
    var prevDarkMode: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.standard.bool(forKey: "AltimeterReadingReady") {
            let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(CJTableView1.updateTime(_:)), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        }
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return rowHeight + 30
        } else if indexPath.row == 4 {
            return rowHeight - 40
        }
        
        return (rowHeight + 10)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if UserDefaults.standard.bool(forKey: "DarkMode") != prevDarkMode {
            cellArray = [nil, nil, nil, nil, nil]
        }
        
        if let _: AnyObject = cellArray[indexPath.row] {
            // Get stored cell from array
            return cellArray[indexPath.row] as! CJTableView1_Cell
        } else {
            // Initialize cell if cell is not stored in array
            let cell = Bundle.main.loadNibNamed("CJTableView1_Cell", owner: self, options: nil)?[0] as? CJTableView1_Cell
            var imageName = "Daytime_\(indexPath.row + 1)"
            if UserDefaults.standard.bool(forKey: "DarkMode") {
                imageName = "Night_\(indexPath.row + 1)"
                self.prevDarkMode = true
            } else {
                self.prevDarkMode = false
            }
        
            // Set Background Images
            cell!.backgroundView = UIImageView(image: UIImage(named: imageName))
            cell!.backgroundView?.contentMode = .scaleAspectFill
            cell!.backgroundView?.clipsToBounds = true
            
            cell!.selectedBackgroundView = UIImageView(image: UIImage(named: imageName))
            cell!.selectedBackgroundView?.contentMode = .scaleAspectFill
            cell!.selectedBackgroundView?.clipsToBounds = true
            
            cell!.index = indexPath.row
            cell!.tableView = self
            // Set label texts
            switch indexPath.row {
            case 0:
                cell!.label_Title.center = CGPoint(x: cell!.label_Title.center.x, y: cell!.label_Title.center.y + 20)
                cell!.label_Title.text = "I, a Simple Guy"
            case 1:
                cell!.label_Title.text = "Never Stop Learning"
            case 2:
                cell!.label_Title.text = "Hacker's Gonna Hack"
            case 3:
                cell!.label_Title.text = "Life's Good"
            case 4:
                let cell_Barometer = Bundle.main.loadNibNamed("CJTableView1_Cell", owner: self, options: nil)?[1] as? CJTableView1_Cell_Barometer
                cell_Barometer!.view_TableViewController = self
                if UserDefaults.standard.bool(forKey: "DarkMode") {
                    cell_Barometer!.setDarkMode()
                }
                return cell_Barometer!
            default:
                cell!.label_Title.text = ""
            }
            
            // Store cell in array and return it
            cellArray[indexPath.row] = cell!
            return cell!
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 4 {
            for index in 0..<5 {
                tableView.cellForRow(at: IndexPath(row: index, section: 0))?.alpha = 0
            }
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
    }
    

    func updateTime(_ timer: Timer) {
        if let barometerCell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? CJTableView1_Cell_Barometer {
            barometerCell.timerTick(nil)
        }
    }
}
