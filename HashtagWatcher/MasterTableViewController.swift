//
//  MasterTableViewController.swift
//  HashtagWatcher
//
//  Created by Shubhit Singh on 7/24/15.
//  Copyright (c) 2015 Shubhit Singh. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class MasterTableViewController: UITableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    var hashtags : NSMutableArray! = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() == nil) {
            var loginViewController = PFLogInViewController()
            loginViewController.delegate = self
            var signupViewController = PFSignUpViewController()
            signupViewController.delegate = self
            
            loginViewController.signUpController = signupViewController
            self.presentViewController(loginViewController, animated: true, completion: nil)
        } else {
            self.fetchAllObjectsFromLocalDatastore()
            self.fetchAllObjects()
        }
    }
    
    func fetchAllObjectsFromLocalDatastore() {
        var query: PFQuery = PFQuery(className: "Hashtag")
        query.fromLocalDatastore()
        if let username = PFUser.currentUser()?.username {
            query.whereKey("username", equalTo: username)
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if (error == nil) {
                    var temp : NSArray = objects!
                    self.hashtags = temp.mutableCopy() as! NSMutableArray
                    self.tableView.reloadData()
                } else {
                    println(error?.userInfo)
                }
                
                
            }
        }
        
    }
    
    func fetchAllObjects() {
        PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        var query: PFQuery = PFQuery(className: "Hashtag")
        if let username = PFUser.currentUser()?.username {
            query.whereKey("username", equalTo: username)
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if (error == nil) {
                    PFObject.pinAllInBackground(objects, block: nil)
                    self.fetchAllObjectsFromLocalDatastore()
                } else {
                    println(error?.userInfo)
                }
                
                
            }
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        println("Failed to login")
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        if let password = info["password"] as? String {
            return count(password.utf16) >= 8
        } else {
            return false
        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        println("Failed to signup")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        println("User dismissed signup")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return hashtags.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("hashtagCell", forIndexPath: indexPath) as! MasterTableViewCell
        
        var object : PFObject = self.hashtags.objectAtIndex(indexPath.row) as! PFObject
        cell.textLabel?.text = "#"+(object["text"] as! String)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("viewFeed", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
        if (segue.identifier == "viewFeed") {
            var upcoming : FeedTableViewController = segue.destinationViewController as! FeedTableViewController
            let indexPath = self.tableView.indexPathForSelectedRow()!
            var object: PFObject = self.hashtags.objectAtIndex(indexPath.row) as! PFObject
            upcoming.object = object
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else if (segue.identifier == "addHashtag") {
            var upcoming : AddHashtagTableViewController = segue.destinationViewController as! AddHashtagTableViewController
            let indexPath = self.tableView.indexPathForSelectedRow()!
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    

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
