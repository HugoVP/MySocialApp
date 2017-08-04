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
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabelView: UITextView!
    @IBOutlet weak var likesLabelView: UILabel!
    
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.rounded()
    }
    
    func configureCell(_ post: Post, image: UIImage? = nil) {
        self.post = post
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
    }
}
