//
//  LoginViewCellViewController.swift
//  BlogPost
//
//  Created by Andela Developer on 4/22/15.
//  Copyright (c) 2015 Andela. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var token = ""
var globalUsername = ""
var globalPassword = ""
var globalEmail = ""
class LoginViewCellViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func authenticate(){
        if validateForm(){
            let loginData = ["username" : username.text, "password" : password.text]
            request(.POST, "https://sleepy-escarpment-5204.herokuapp.com/api/v1/signin", parameters: loginData)
                .responseJSON { (request, response, data, error) in
                    let data = JSON(data!)
                    println(data)
                    self.activityIndicatorView.stopAnimating()
                    token = data["token"].stringValue
                    globalUsername = self.username.text
                    globalPassword = self.password.text
                    if token.isEmpty{
                        let alertController = UIAlertController(title: "Oops", message: "Username or Password is Incorrect", preferredStyle: .Alert)
                        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(alertAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }else{
                        self.performSegueWithIdentifier("showBlogPosts", sender: nil)
                    }
            }
        }
    }
    
    @IBAction func close(segue:UIStoryboardSegue) {
        
    }
    
    
    func validateForm() -> Bool{
        var errorField = ""
        
        if username.text.isEmpty {
            errorField = "username"
        }else if password.text.isEmpty {
            errorField = "password"
        }
        
        if errorField != "" {
            let alertController = UIAlertController(title: "Oops", message: "Fill in your " + errorField + " to continue", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }else{
            return true
        }

    }

    @IBAction func signIn(sender: UIButton) {
        if validateForm() {
            activityIndicatorView.startAnimating()
            authenticate()
        }
    }
    
    @IBAction func goToSignUpPage(sender: UIButton) {
        self.performSegueWithIdentifier("showSignUpPage", sender: nil)
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
