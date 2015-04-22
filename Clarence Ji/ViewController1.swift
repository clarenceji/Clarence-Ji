//
//  ViewController1.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/21/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class ViewController1: UIViewController {

    @IBOutlet var view_: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        view = NSBundle.mainBundle().loadNibNamed("CJProjectDetailPopupView", owner: self, options: nil)[0] as! CJProjectDetailPopupView
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
