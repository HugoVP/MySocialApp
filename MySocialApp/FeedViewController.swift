//
//  FeedViewController.swift
//  MySocialApp
//
//  Created by Hugo on 02/08/17.
//  Copyright © 2017 Hugo. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedViewController: UIViewController {
    @IBOutlet weak var headerView: FancyView!
    @IBOutlet weak var controlsView: FancyView!
    @IBOutlet weak var addImgImageView: CircleImageView!
    @IBOutlet weak var addPostButtonView: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.addDropShadow()
        
        controlsView.addDropShadow()
        
        addImgImageView.addDropShadow()
        addImgImageView.rounded()
        
        addPostButtonView.addDropShadow()
        addPostButtonView.rounded()
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("AUTH: ID removed from keychain: \(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "SegueToSignInViewController", sender: "nil")
    }
}
