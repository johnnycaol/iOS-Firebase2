//
//  ViewController.swift
//  quick-chat
//
//  Created by Luchao Cao on 2016-06-23.
//  Copyright © 2016 Luchao Cao. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard().value(forKey: UID) != nil {
            self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    @IBAction func fbBtnPressed(sender: UIButton!) {
        print("Facebook Login Clicked")
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.loginBehavior = .systemAccount

        // Some legacy code from the video
//        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (facebookResult, facebookError) -> Void in
//            if facebookError != nil {
//                print("Facebook login failed. Error \(facebookError)")
//            } else {
//                let accessToken = FBSDKAccessToken.current().tokenString
//                print("Successfully logged in with facebook. \(accessToken)")
//            }
//        }

        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else {
                //let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                FIRAuth.auth()?.signIn(with: credential, completion: { (authData, error) in
                    if error != nil {
                        print("Login failed. \(error)")
                    } else {
                        //login successful
                        print("Login via facebook success: \(authData?.uid)")
                        
                        //Parse the authData, TODO: create a user model to do this for me
                        let user = [
                            "uid": (authData?.uid)!,
                            "email": (authData?.email)!,
                            "provider": "facebook",
                            "providerId": (authData?.providerID)!,
                            "displayName": (authData?.displayName)!,
                            "profileImageURL": (authData?.photoURL?.absoluteString)!
                        ]
                        
                        // Create the user in firebase
                        DataService.ds.createFirebaseUser(uid: authData!.uid, user: user)
                        
                        // Set the uid so that I don't need to sign in with facebook again next time
                        //UserDefaults.standard().setValue(authData?.uid, forKey: UID)
                        self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                    }
                })
            }
        }
    }
}

