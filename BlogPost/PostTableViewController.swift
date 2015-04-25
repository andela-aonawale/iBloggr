//
//  PostTableViewController.swift
//  BlogPost
//
//  Created by Andela Developer on 4/18/15.
//  Copyright (c) 2015 Andela. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PostTableViewController: UITableViewController, UISearchResultsUpdating {

    var posts = [Post]()
    var searchController:UISearchController!
    var searchResults = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        getPosts()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        //tableView.estimatedRowHeight = 80
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func refresh(sender:AnyObject){
        self.posts = []
        getPosts()
        self.refreshControl?.endRefreshing()
    }
    
    func filterContentForSearchText(searchText: String) {
        searchResults = posts.filter({(post: Post) -> Bool in
            let nameMatch = post.title.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return nameMatch != nil
        })
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        filterContentForSearchText(searchText)
        tableView.reloadData()
    }
    
    /*override func viewWillAppear(animated: Bool) {
        //self.posts = []
        //getPosts()
        self.tableView.reloadData()
    }*/
    
    override func viewDidAppear(animated: Bool) {
        self.posts = []
        getPosts()
    }
    
    func getPosts(){
        request(.GET, "https://sleepy-escarpment-5204.herokuapp.com/api/v1/posts")
        .responseJSON { (request, response, data, error) in
            let json = JSON(data!)
            if let jsonArray = json.array {
                for post in jsonArray {
                    var onepost = Post(id:post["_id"].stringValue, title:post["title"].stringValue, author:post["author"].stringValue, post:post["post"].stringValue, created_on:post["created_on"].stringValue, updated_on:post["updated_on"].stringValue)
                        self.posts.append(onepost)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    /*func deletePost(id: String){
        request(.DELETE, "http://localhost:8222/api/v1/post/" + id)
        .responseJSON { (request, response, data, error) in
            println(data)
        }
    }*/
    
    func deletePost(id: String){
        var headers = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        headers["token"] = token
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = headers
        
        Alamofire.Manager(configuration: configuration)
            .request(.DELETE, "https://sleepy-escarpment-5204.herokuapp.com/api/v1/post/" + id)
            .responseJSON { (request, response, data, error) in
                var data = JSON(data!)
                println(data)
        }
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
        if searchController.active {
                return searchResults.count
            } else {
                return self.posts.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomTableViewCell
        
        let post = (searchController.active) ? searchResults[indexPath.row] : posts[indexPath.row]
        // Configure the cell...
        cell.titleLabel.text = post.title
        cell.postLabel.text = post.post
        cell.thumbnailImageView.image = UIImage(named: "blog.jpg")
        cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.width / 2
        cell.thumbnailImageView.clipsToBounds = true
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //self.posts.removeAtIndex(indexPath.row)
        //self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var shareAction = UITableViewRowAction(style: .Default, title: "Share", handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .ActionSheet)
            let twitterAction = UIAlertAction(title: "Twitter", style: .Default, handler: nil)
            let facebookAction = UIAlertAction(title: "Facebook", style: .Default, handler: nil)
            let emailAction = UIAlertAction(title: "Email", style: .Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(facebookAction)
            shareMenu.addAction(emailAction)
            shareMenu.addAction(cancelAction)
            
            self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        
        shareAction.backgroundColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
        
        var deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Delete the row from the data source
            self.deletePost(self.posts[indexPath.row].id)
            self.posts.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        })
        //tableView.deselectRowAtIndexPath(indexPath, animated: false)
        return [deleteAction, shareAction]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        searchController.active = false
        if segue.identifier == "showPostDetail" {
            if let row = self.tableView.indexPathForSelectedRow()?.row {
                let destinationController = segue.destinationViewController as! DetailViewController
            destinationController.post = (searchController.active) ? searchResults[row] : posts[row]
            }
        }
    }

    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        if searchController.active {
            return false
        } else {
            return true
        }
    }
    
    

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
