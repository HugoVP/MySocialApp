//
//  Post.swift
//  MySocialApp
//
//  Created by Hugo on 03/08/17.
//  Copyright © 2017 Hugo. All rights reserved.
//

import Foundation

struct Post {
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    
    var caption: String {
        return _caption
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        _caption = caption
        _imageUrl = imageUrl
        _likes = likes
    }
    
    init(postKey: String, data: Dictionary<String, Any>) {
        _postKey = postKey
        
        if let caption = data["caption"] as? String {
            _caption = caption
        }
        
        if let imageUrl = data["imageUrl"] as? String {
            _imageUrl = imageUrl
        }
        
        if let likes = data["likes"] as? Int {
            _likes = likes
        }
    }
}
