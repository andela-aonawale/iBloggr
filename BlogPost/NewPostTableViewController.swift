//
//  NewPostTableViewController.swift
//  BlogPost
//
//  Created by Andela Developer on 4/22/15.
//  Copyright (c) 2015 Andela. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewPostTableViewController: UITableViewController {

    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postContent: UITextView!
    
    // TODO when the Publish button is clicked
    @IBAction func publishPost(sender: UIBarButtonItem) {
        if validateForm(){
            createPost()
            self.performSegueWithIdentifier("publishPostBackToHome", sender: self)
        }
    }
    
    // Validate the form
    func validateForm() -> Bool{
        var errorField = ""
        
        if postTitle.text == "" {
            errorField = "title"
        }else if postContent.text.isEmpty {
            errorField = "post content"
        }
        
        if errorField != "" {
            let alertController = UIAlertController(title: nil, message: "We can't proceed as you forget to fill in the post " + errorField + ". All fields are mandatory.", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }else{
            return true
        }
    }
    
    // make post request to api with form data
    /*func createPost(){
        let parameters = ["title" : postTitle.text, "post" : postContent.text]
        request(.POST, "http://localhost:8222/api/v1/newpost", parameters: parameters)
            .responseJSON { (request, response, data, error) in
                var data = JSON(data!)
                println(data)
        }
    }*/
    
    func createPost(){
        let parameters = ["title" : postTitle.text, "post" : postContent.text]
        var headers = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        headers["token"] = token
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = headers
        
        Alamofire.Manager(configuration: configuration)
        .request(.POST, "https://sleepy-escarpment-5204.herokuapp.com/api/v1/newpost", parameters: parameters, encoding: .JSON)
        .responseJSON { (request, response, data, error) in
            var data = JSON(data!)
            println(data)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        postContent.layer.cornerRadius = 5.0
        postContent.layer.masksToBounds = true
        postContent.layer.borderColor = UIColor( red: 230/255, green: 230/255, blue:230/255, alpha: 1.0 ).CGColor
        postContent.layer.borderWidth = 1.0
        
        self.tableView.separatorColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.8)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifire = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }*/
    

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
