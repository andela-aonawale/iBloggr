//
//  EditPostViewController.swift
//  BlogPost
//
//  Created by Andela Developer on 4/24/15.
//  Copyright (c) 2015 Andela. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditPostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editedPost.layer.cornerRadius = 5.0
        editedPost.layer.masksToBounds = true
        editedPost.layer.borderColor = UIColor( red: 230/255, green: 230/255, blue:230/255, alpha: 1.0 ).CGColor
        editedPost.layer.borderWidth = 1.0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.editedTitle.text = post.title
        self.editedPost.text = post.post
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var post: Post!

    @IBOutlet weak var editedTitle: UITextField!
    
    @IBOutlet weak var editedPost: UITextView!
    
    
    
    @IBAction func savePost(sender: UIBarButtonItem) {
        if validateForm(){
            editRequest(self.post.id)
            let alertController = UIAlertController(title: nil, message: "Post Updated", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: {
                (alert: UIAlertAction!) in
                self.performSegueWithIdentifier("backToEditedPost", sender: self)
            })
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func editRequest(id:String){
        let parameters = ["title" : editedTitle.text, "post" : editedPost.text]
        var headers = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        headers["token"] = token
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = headers
        
        Alamofire.Manager(configuration: configuration)
            .request(.PUT, "https://sleepy-escarpment-5204.herokuapp.com/api/v1/post/" + id, parameters: parameters, encoding: .JSON)
            .responseJSON { (request, response, data, error) in
                var data = JSON(data!)
                println(data)
        }
    }
    
    func validateForm() -> Bool{
        var errorField = ""
        
        if editedTitle.text == "" {
            errorField = "title"
        }else if editedPost.text.isEmpty {
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
