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
import SwiftKeychainWrapper

class SignInViewController: UIViewController {
    @IBOutlet weak var headerView: FancyView!
    @IBOutlet weak var fbButtonView: RoundButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButtonView: FancyButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.addDropShadow()
        
        fbButtonView.addDropShadow()
        fbButtonView.rounded()
        
        signInButtonView.addDropShadow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("AUTH: ID found in keychain")
            performSegue(withIdentifier: "SegueToFeedViewController", sender: nil)
        }
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
                            self.completeSignInWith(user)
                        }
                    }
                } else {
                    print("AUTH: Successfully authenticated with Firebase using mail")
                    self.completeSignInWith(user)
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
                self.completeSignInWith(user)
            }
        }
    }
    
    func completeSignInWith(_ user: User?) {
        if user != nil, let userID = user?.uid {
            let keychainResult = KeychainWrapper.standard.set(userID, forKey: KEY_UID)
            print("AUTH: Data saved to keychain: \(keychainResult)")
            performSegue(withIdentifier: "SegueToFeedViewController", sender: nil)
        }
    }
}
