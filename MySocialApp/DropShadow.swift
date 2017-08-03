//
//  DropShadow.swift
//  MySocialApp
//
//  Created by Hugo on 02/08/17.
//  Copyright © 2017 Hugo. All rights reserved.
//

import UIKit

protocol DropShadow {}

extension DropShadow where Self: UIView {
    func addDropShadow() {
        layer.shadowColor = UIColor(
            red: SHADOW_GRAY,
            green: SHADOW_GRAY,
            blue: SHADOW_GRAY,
            alpha: 0.6
        ).cgColor
        
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        
        layer.shadowOffset = CGSize(
            width: 1.0,
            height: 1.0
        )
        
        layer.cornerRadius = 2.0
    }
}
