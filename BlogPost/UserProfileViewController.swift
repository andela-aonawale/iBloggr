//
//  UserProfileViewController.swift
//  BlogPost
//
//  Created by Andela Developer on 4/23/15.
//  Copyright (c) 2015 Andela. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.text = globalUsername
        self.email.text = globalEmail
        self.password.text = globalPassword
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    /*func deleteRequest(username: String){
        request(.DELETE, "http://localhost:8222/api/v1/user/" + username, parameters: ["token": token])
            .responseJSON { (request, response, data, error) in
                let data = JSON(data!)
                println(data)
        }
    }*/
    
    func deleteRequest(username: String){
        var headers = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        headers["token"] = token
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = headers
        
        Alamofire.Manager(configuration: configuration)
            .request(.DELETE, "https://sleepy-escarpment-5204.herokuapp.com/api/v1/user/" + username)
            .responseJSON { (request, response, data, error) in
                var data = JSON(data!)
                println(data)
        }
    }
    
    func signOutRequest(username: String){
        var headers = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        headers["token"] = token
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = headers
        
        Alamofire.Manager(configuration: configuration)
            .request(.POST, "https://sleepy-escarpment-5204.herokuapp.com/api/v1/user/" + username)
            .responseJSON { (request, response, data, error) in
                var data = JSON(data!)
                println(data)
        }
    }
    
    func updateRequest(username: String){
        let parameters:[String : String]
        if self.email.text.isEmpty {
            parameters = ["username":self.username.text, "password":self.password.text]
        }else{
            parameters = ["username":self.username.text, "password":self.password.text, "email": self.email.text]
        }
        
        var headers = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        headers["token"] = token
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = headers
        
        Alamofire.Manager(configuration: configuration)
            .request(.PUT, "https://sleepy-escarpment-5204.herokuapp.com/api/v1/user/" + username, parameters: parameters, encoding: .JSON)
            .responseJSON { (request, response, data, error) in
                var data = JSON(data!)
                globalUsername = self.username.text
                globalPassword = self.password.text
                globalEmail = self.email.text
                println(data)
        }
    }
    
    func validateForm() -> Bool{
        var errorField = ""
        
        if username.text.isEmpty {
            errorField = "username"
        }else if password.text.isEmpty {
            errorField = "password"
        }/*else if email.text.isEmpty {
            errorField = "email"
        }*/
        
        if errorField != "" {
            let alertController = UIAlertController(title: nil, message: "Fill in your " + errorField + " to continue", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }else{
            return true
        }
        
    }
    
    @IBAction func updateProfile(sender: UIButton) {
        if validateForm(){
            updateRequest(globalUsername)
            let alertController = UIAlertController(title: nil, message: "Your Account Have Been Updated", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func signOut(sender: UIButton) {
        signOutRequest(globalUsername)
        self.performSegueWithIdentifier("signOutToLoginPage", sender: nil)
    }
    
    @IBAction func deleteAccount(sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: "Do you really want to do this?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .Default, handler: {
            (alert: UIAlertAction!) in
            self.deleteRequest(globalUsername)
            self.performSegueWithIdentifier("deleteAccountToSignUpPage", sender: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.presentViewController(alertController, animated: true, completion: nil)
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
