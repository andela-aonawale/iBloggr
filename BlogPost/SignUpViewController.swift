//
//  SignUpViewController.swift
//  BlogPost
//
//  Created by Andela Developer on 4/23/15.
//  Copyright (c) 2015 Andela. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    //var token = ""
    
    func createAccount(){
        
        let signUpData = ["username" : username.text, "email" : email.text, "password" : password.text]
        request(.POST, "https://sleepy-escarpment-5204.herokuapp.com/api/v1/signup", parameters: signUpData)
            .responseJSON { (request, response, data, error) in
                let data = JSON(data!)
                println(data)
                self.activityIndicatorView.stopAnimating()
                token = data["token"].stringValue
                
                if token.isEmpty{
                    let alertController = UIAlertController(title: nil, message: data["message"].stringValue, preferredStyle: .Alert)
                    let alertAction = UIAlertAction(title: "Try again", style: .Default, handler: nil)
                    alertController.addAction(alertAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }else{
                    let alertController = UIAlertController(title: nil, message: data["message"].stringValue, preferredStyle: .Alert)
                    let alertAction = UIAlertAction(title: "Continue", style: .Default, handler: {
                        (alert: UIAlertAction!) in
                        self.performSegueWithIdentifier("showBlogPosts", sender: nil)
                    })
                    alertController.addAction(alertAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    globalUsername = self.username.text
                    globalPassword = self.password.text
                    globalEmail = self.email.text
                    println("Account created, token is: \(token)")
                }
        }
    }
    
    func validateForm() -> Bool{
        var errorField = ""
        
        if username.text.isEmpty {
            errorField = "username"
        }else if email.text.isEmpty {
            errorField = "email"
        }else if password.text.isEmpty {
            errorField = "password"
        }else if confirmPassword.text.isEmpty {
            errorField = "confirm password"
        }
        
        if errorField != "" {
            let alertController = UIAlertController(title: nil, message: "Fill in your " + errorField + " to continue", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        if password.text != confirmPassword.text {
                let alertController = UIAlertController(title: nil, message: "Password fields do not match", preferredStyle: .Alert)
                let alertAction = UIAlertAction(title: "Try again", style: .Default, handler: nil)
                alertController.addAction(alertAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }else {
            return true
        }
        
    }
    
    @IBAction func signUp(sender: UIButton) {
        if validateForm() {
            activityIndicatorView.startAnimating()
            createAccount()
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
