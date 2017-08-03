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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.addDropShadow()
        
        controlsView.addDropShadow()
        
        addImgImageView.addDropShadow()
        addImgImageView.rounded()
        
        addPostButtonView.addDropShadow()
        addPostButtonView.rounded()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostCell.self)
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("AUTH: ID removed from keychain: \(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "SegueToSignInViewController", sender: "nil")
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 512
    }
}

extension FeedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postCell = tableView.dequeueReusableCell(for: indexPath) as PostCell
        postCell.configureCell(withPost: Post(username: "Test User"))
        
        return postCell
    }
}
