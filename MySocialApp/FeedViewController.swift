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
    
    var posts = [Post]()
    
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
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                snaps.forEach { (snap) in
                    print("snap: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let post = Post(
                            postKey: snap.key,
                            data: postDict
                        )
                        
                        self.posts.append(post)
                        print("post: \(post)")
                    }
                }
            }
            
            self.tableView.reloadData()
        })
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
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
//        print("post: \(post)")
        
        let postCell = tableView.dequeueReusableCell(for: indexPath) as PostCell
        postCell.configurePostCell(post)
        
        return postCell
    }
}
