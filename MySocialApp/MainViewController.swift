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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func fbButtonPressed(_ sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()

        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil {
                print("AUTH: Unable to authenticate with Facebook")
            } else if (result?.isCancelled)! {
                print("AUTH: User cancelled Facebook authentication")
            } else {
                print("AUTH: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    @IBAction func singInButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
                if err != nil {
                    Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
                        if err != nil {
                            print("AUTH: Unable to authenticate with Firebase using mail: \(String(describing: err!))")
                        } else {
                            print("AUTH: Successfully authenticated with Firebase using mail; account created")
                        }
                    }
                } else {
                    print("AUTH: Successfully authenticated with Firebase using mail")
                }
            }
        }
    }

    func firebaseAuth(_ credencial: AuthCredential) {
        Auth.auth().signIn(with: credencial) { (user, err) in
            if err != nil {
                print("AUTH: Unable to authenticate with Firebase: \(String(describing: err!))")
            } else {
                print("AUTH: Successfully authenticated with Firebase")
            }
        }
    }
}
