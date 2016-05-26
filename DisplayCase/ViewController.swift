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
import FirebaseDatabase
import PMAlertController



class ViewController: UIViewController {
    @IBOutlet var fbButton: MaterialButton!
    @IBOutlet var emailTextField: MaterialTextField!
    @IBOutlet var passTextField: MaterialTextField!
    
     var ref:FIRDatabaseReference!
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        if FIRAuth.auth()?.currentUser != nil {
//        self.performSegueWithIdentifier("showLoggedIn", sender: self)
//        }
        
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
                        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                        changeRequest?.displayName = "UserThat"
                        changeRequest?.commitChangesWithCompletion() { (error) in
                            
                            if let error = error {
                                // self.showMessagePrompt(error.localizedDescription)
                                print(error)
                                return
                            }
                            // [START basic_write]
                           self.ref.child("users").child(user!.uid).setValue(["username": "UserFromFB"])
//                            //                        let key = self.ref.child("posts").childByAutoId().key
//                            //                        self.ref.child("posts").child(key).setValue("This is it")
//                            let key = self.ref.child("posts").childByAutoId().key
//                            let post = ["uid": user!.uid,
//                                "author": "Kash2",
//                                "url": "www.url.com/",
//                                "body": "This is another test post description"]
//                            let childUpdates = ["/posts/\(key)": post]
//                            self.ref.child("users").child(user!.uid).child("posts").setValue([key:"true"])
                            self.ref.child("users").child(user!.uid).child("provider").setValue("Facebook")
                          //  self.ref.updateChildValues(childUpdates)
                            // [END basic_write]
                            
                            
                        }
                        
                        //print("uuid is: " +  NSUserDefaults.standardUserDefaults().stringForKey(uuidKey)!)
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
        ref = FIRDatabase.database().reference()
        
        
        
        
//        if FIRAuth.auth()?.currentUser != nil {
//            self.performSegueWithIdentifier("showLoggedIn", sender: self)
//        }
    
            
        
    }
    
    @IBAction func emailButtonPressed(sender: AnyObject) {
        if emailTextField.text != "" && passTextField.text != "" {
        FIRAuth.auth()?.signInWithEmail(emailTextField.text!, password: passTextField.text!, completion: { (user, error) in
            if error != nil {FIRAuth.auth()?.createUserWithEmail(self.emailTextField.text!, password: self.passTextField.text!, completion: { (user, error) in
                NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: uuidKey)
//                self.ref.child("users").child(user!.uid).setValue(["username": "USER!"])
                NSUserDefaults.standardUserDefaults().synchronize()
                // print("uuid is: " +  NSUserDefaults.standardUserDefaults().stringForKey(uuidKey)!)
               
                    let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                    changeRequest?.displayName = "UserThat"
                    changeRequest?.commitChangesWithCompletion() { (error) in
                      
                            if let error = error {
                                print(error)
                               // self.showMessagePrompt(error.localizedDescription)
                                return
                            }
                            // [START basic_write]
                            self.ref.child("users").child(user!.uid).setValue(["username": "User2"])
//                        let key = self.ref.child("posts").childByAutoId().key
//                        self.ref.child("posts").child(key).setValue("This is it")
                        let key = self.ref.child("posts").childByAutoId().key
                        let post = ["uid": user!.uid,
                            "author": "Kash2",
                            "url": "www.url.com/",
                            "body": "This is another test post description"]
                        let childUpdates = ["/posts/\(key)": post]
                        self.ref.child("users").child(user!.uid).child("posts").setValue([key:"true"])
                        self.ref.child("users").child(user!.uid).child("provider").setValue(user?.providerID)
                        self.ref.updateChildValues(childUpdates)
                            // [END basic_write]
                        
                        
                    }
             
                
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

