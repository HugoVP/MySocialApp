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
    @IBOutlet weak var addCaptionTextFieldView: UITextField!
    @IBOutlet weak var addPostButtonView: RoundButton!
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageChache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
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
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts = [] // Reset posts array
            
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                snaps.forEach { (snap) in
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let post = Post(
                            postKey: snap.key,
                            data: postDict
                        )
                        
                        self.posts.append(post)
                        
                        print("POST: \(post)")
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func postToFirebase(imageUrl: String) {
        let post: Dictionary<String, Any> = [
            "caption": addCaptionTextFieldView.text!,
            "imageUrl": imageUrl,
            "likes": 0
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        addCaptionTextFieldView.text = ""
        imageSelected = false
        addImgImageView.image = UIImage(named: "add-image")
        tableView.reloadData()
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("AUTH: ID removed from keychain: \(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "SegueToSignInViewController", sender: "nil")
    }
    
    @IBAction func addImgImageViewPressed(_sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addPostButtonPressed(_ sender: UIButton) {
        guard let caption = addCaptionTextFieldView.text, caption != "" else {
            print("Caption must be entered")
            return
        }
        
        guard let image = addImgImageView.image, imageSelected else {
            print("An image must be selected")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let imageUUID = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imageUUID).putData(imageData, metadata: metadata) { (metadata, err) in
                if err != nil {
                    print("Unable to upload image to Firebase Storage")
                } else {
                    print("Successfully uploaded image to Firebase Storage")
                    
                    if let downloadURL = metadata?.downloadURL()?.absoluteString {
                        self.postToFirebase(imageUrl: downloadURL)
                    }
                }
            }
        }
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
        let postCell = tableView.dequeueReusableCell(for: indexPath) as PostCell
        
        if let postImage = FeedViewController.imageChache.object(forKey: post.imageUrl as NSString) {
            postCell.configureCell(post, image: postImage)
        } else {
            postCell.configureCell(post)
        }
        
        return postCell
    }
}

extension FeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImgImageView.image = image
            imageSelected = true
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addImgImageView.image = image
            imageSelected = true
        } else {
            print("A valid image wasn't selected")
        }
        
        dismiss(animated: true, completion: nil)
    }
}
