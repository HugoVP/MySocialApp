//
//  ReusableView.swift
//  MySocialApp
//
//  Created by Hugo on 03/08/17.
//  Copyright © 2017 Hugo. All rights reserved.
//

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
