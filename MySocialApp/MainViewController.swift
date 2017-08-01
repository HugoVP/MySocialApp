//
//  MainViewController.swift
//  MySocialApp
//
//  Created by Hugo on 29/07/17.
//  Copyright © 2017 Hugo. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func fbButtonPressed(_ sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()

        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil {
                print("Unable to authenticate with Facebook")
            } else if (result?.isCancelled)! {
                print("User cancelled Facebook authentication")
            } else {
                print("Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }

    func firebaseAuth(_ credencial: AuthCredential) {
        Auth.auth().signIn(with: credencial) { (user, err) in
            if err != nil {
                print("Unable to authenticate with Firebase: \(String(describing: err))")
            } else {
                print("Successfully authenticated with Firebase")
            }
        }
    }
}
