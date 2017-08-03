//
//  Post.swift
//  MySocialApp
//
//  Created by Hugo on 03/08/17.
//  Copyright © 2017 Hugo. All rights reserved.
//

import Foundation

struct Post {
    private var _username: String!
    
    var username: String {
        return _username
    }
    
    init(username: String) {
        _username = username
    }
}
