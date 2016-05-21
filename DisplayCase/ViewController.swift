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



class ViewController: UIViewController {
    @IBOutlet var fbButton: MaterialButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        fbButton.setTitle("FB Login", forState: UIControlState.Normal)
        fbButton.addTarget(self, action: #selector(ViewController.loginButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loginButtonClicked() {
        let login:FBSDKLoginManager = FBSDKLoginManager.init()
       
       
        login.logInWithReadPermissions(["email"], fromViewController: self) { (FBSDKLoginManagerLoginResult, error) in
            if (error != nil) {
            print(error.localizedDescription)}
            else {
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
                    //
                })
                //print(FBSDKProfile.currentProfile().firstName)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

