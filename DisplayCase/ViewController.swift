//
//  ViewController.swift
//  DisplayCase
//
//  Created by Kashish Goel on 2016-05-20.
//  Copyright © 2016 Kashish Goel. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import PMAlertController



class ViewController: UIViewController {
    @IBOutlet var fbButton: MaterialButton!
    @IBOutlet var emailTextField: MaterialTextField!
    @IBOutlet var passTextField: MaterialTextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fbButton.setTitle("FB Login", forState: UIControlState.Normal)
        fbButton.addTarget(self, action: #selector(ViewController.loginButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loginButtonClicked() {
        let login:FBSDKLoginManager = FBSDKLoginManager.init()
        
        if (FBSDKAccessToken.currentAccessToken() != nil){
            
            self.performSegueWithIdentifier("showLoggedIn", sender: self)
            
        }
            
        else {
            login.logInWithReadPermissions(["email"], fromViewController: self) { (FBSDKLoginManagerLoginResult, error) in
                if (error != nil) {
                    
                    print(error.localizedDescription)}
                else {
                    
                    let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                    FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
                        NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: uuidKey)
                        NSUserDefaults.standardUserDefaults().synchronize()
                        print("uuid is: " +  NSUserDefaults.standardUserDefaults().stringForKey(uuidKey)!)
                        self.performSegueWithIdentifier("showLoggedIn", sender: self)
                    })
                }
            }
       }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
         //   print("uuid is: " +  NSUserDefaults.standardUserDefaults().stringForKey(uuidKey)!)
            super.viewDidAppear(animated)

            if NSUserDefaults.standardUserDefaults().valueForKey(uuidKey) != nil {
                    self.performSegueWithIdentifier("showLoggedIn", sender: self)
            }
    
            
        
    }
    
    @IBAction func emailButtonPressed(sender: AnyObject) {
        if emailTextField.text != "" && passTextField.text != "" {
        FIRAuth.auth()?.signInWithEmail(emailTextField.text!, password: passTextField.text!, completion: { (user, error) in
            if error != nil {FIRAuth.auth()?.createUserWithEmail(self.emailTextField.text!, password: self.passTextField.text!, completion: { (user, error) in
                NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: uuidKey)
                NSUserDefaults.standardUserDefaults().synchronize()
                 print("uuid is: " +  NSUserDefaults.standardUserDefaults().stringForKey(uuidKey)!)
                
                    self.performSegueWithIdentifier("showLoggedIn", sender: self)
               
                //
            })}
            else {
                    self.performSegueWithIdentifier("showLoggedIn", sender: self)
            }
        })
        
        }
        
        else {
        showError("Something went wrong!", message: "You forgot to add a username/password!")
        }
        
    }
    
    func showError(title: String, message: String){
    let alertVC = PMAlertController(title: title, description: message, image: UIImage(named: "flag.png"), style: PMAlertControllerStyle.Alert)
        
        alertVC.alertImage = UIImageView(image: UIImage(named: "alertBG"))
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .Cancel, action: { 
            print("Cancel button tapped on AlertVc")
        }))
        
        alertVC.addAction(PMAlertAction(title: "Ok", style: .Default, action: { 
            print("Ok clicked on AlertVc")
        }))
        self.presentViewController(alertVC, animated: true, completion: nil)
    
    }
    
}

