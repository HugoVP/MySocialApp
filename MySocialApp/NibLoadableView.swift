//
//  NibLoadableView.swift
//  MySocialApp
//
//  Created by Hugo on 03/08/17.
//  Copyright © 2017 Hugo. All rights reserved.
//

import UIKit

protocol NibLoadableView: class {}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
