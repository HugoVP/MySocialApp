//
//  RoundedView.swift
//  MySocialApp
//
//  Created by Hugo on 02/08/17.
//  Copyright © 2017 Hugo. All rights reserved.
//

import UIKit

protocol RoundedView {}

extension RoundedView where Self: UIView {
    func rounded() {
        layer.cornerRadius = bounds.midX
        
        if let instance = self as? UIButton {
            instance.imageView?.contentMode = .scaleAspectFit
        } else if let instance = self as? UIImageView {
            instance.contentMode = .scaleAspectFit
        }
    }
}
