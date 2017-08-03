//
//  PostTableViewCell.swift
//  MySocialApp
//
//  Created by Hugo on 02/08/17.
//  Copyright © 2017 Hugo. All rights reserved.
//

import UIKit

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
    
    func configurePostCell(_ post: Post) {
        self.post = post
        captionLabelView.text = post.caption
        likesLabelView.text = "Likes \(post.likes)"
    }
}
