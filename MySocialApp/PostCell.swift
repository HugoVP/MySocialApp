//
//  PostTableViewCell.swift
//  MySocialApp
//
//  Created by Hugo on 02/08/17.
//  Copyright © 2017 Hugo. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell, NibLoadableView {
    @IBOutlet weak var profileImageView: CircleImageView!
    @IBOutlet weak var usernameLabelView: UILabel!
    @IBOutlet weak var likesImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabelView: UITextView!
    @IBOutlet weak var likesLabelView: UILabel!
    
    var post: Post!
    private var likesRef: DatabaseReference!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.rounded()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesImageViewTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        likesImageView.addGestureRecognizer(tapGestureRecognizer)
        likesImageView.isUserInteractionEnabled = true
    }
    
    func configureCell(_ post: Post, image: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_CURRENT_USER.child("likes").child(self.post.postKey)
        captionLabelView.text = post.caption
        likesLabelView.text = "Likes \(post.likes)"
        
        if image != nil {
            postImageView.image = image
        } else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)

            ref.getData(maxSize: 2 * 1024 * 1024) { (data, err) in
                if err != nil {
                    print("Unable to download image from Firebase Storage: \(String(describing: err))")
                } else {
                    print("Image downloaded from Firebase Storage")
                    
                    if data != nil {
                        if let image = UIImage(data: data!) {
                            self.postImageView.image = image
                            FeedViewController.imageChache.setObject(image, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            }
        }
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likesImageView.image = UIImage(named: "empty-heart")
            } else {
                self.likesImageView.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    func likesImageViewTapped(_ sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likesImageView.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(toggle: true)
                self.likesRef.setValue(true)
            } else {
                self.likesImageView.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(toggle: false)
                self.likesRef.removeValue()
            }
        })
    }
}
