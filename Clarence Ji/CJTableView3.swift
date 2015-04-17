//
//  CJTableView3.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/16/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit
import MessageUI

class CJTableView3: UITableViewController, UIViewControllerTransitioningDelegate, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController!.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 4
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = NSBundle.mainBundle().loadNibNamed("CJTableView3_Cell", owner: self, options: nil)[0] as! CJTableView3_Cell
        cell.setLabels(indexPath.row)
        cell.tableView = self
        switch indexPath.row {
            
        case 2, 3:
            cell.selectionStyle = .Gray
            cell.accessoryType = .DisclosureIndicator
        default:
            break
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        switch indexPath.row {
        case 2:
            self.sendEmail()
        case 3:
            UIApplication.sharedApplication().openURL(NSURL(string: "http://clarenceji.net")!)
        default:
            break
        }
    }
    
    func sendEmail() {
        let emailViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(emailViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["clarence@clarenceji.net"])
        mailComposerVC.setSubject("Message from Clarence.Ji App")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Cannot Send Email", message: "Please check your email settings and try again.", preferredStyle: .Alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
////        switch indexPath.row {
////        case 0:
////            return 100
////        default:
////            return 15
////        }
//        
//    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
