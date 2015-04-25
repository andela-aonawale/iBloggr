//
//  DetailViewController.swift
//  BlogPost
//
//  Created by Andela Developer on 4/19/15.
//  Copyright (c) 2015 Andela. All rights reserved.
//

import UIKit
var globalPost:Post!
class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.postImageView.image = UIImage(named: "blog.jpg")
        
        self.tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        title = self.post.title
        
        globalPost = post
        
        //tableView.estimatedRowHeight = 36.0
        //tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var tableView:UITableView!
    var post: Post!
    
    @IBAction func editPost(sender: UIBarButtonItem) {
        performSegueWithIdentifier("editPost", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            as! DetailTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        // Configure the cell...
        switch indexPath.row {
            case 0:
            cell.fieldLabel.text = post.title
            case 1:
                cell.fieldLabel.text = post.post
            case 2:
                cell.fieldLabel.text = "By " + post.author
            case 3:
                //let range = advance(post.created_on.endIndex, -14)..<post.created_on.endIndex
                //post.created_on.removeRange(range)
                cell.fieldLabel.text = "Published on " + post.created_on
            case 4:
                //let range = advance(post.updated_on.endIndex, -14)..<post.updated_on.endIndex
                //post.updated_on.removeRange(range)
                cell.fieldLabel.text = "Last updated on " + post.updated_on
            default:
                cell.fieldLabel.text = ""
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //if segue.identifier == "editPostSegue" {
            let destinationController = segue.destinationViewController as! EditPostViewController
            destinationController.post = self.post
        //}
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
