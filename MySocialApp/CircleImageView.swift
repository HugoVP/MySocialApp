//
//  CircleView.swift
//  MySocialApp
//
//  Created by Hugo on 02/08/17.
//  Copyright © 2017 Hugo. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
//    override func didAwakeFromNib() {
//        super.didAwakeFromNib()
//        
//        layer.shadowColor = UIColor(
//            red: SHADOW_GRAY,
//            green: SHADOW_GRAY,
//            blue: SHADOW_GRAY,
//            alpha: 0.6
//            ).cgColor
//        
//        layer.shadowOpacity = 0.8
//        layer.shadowRadius = 5.0
//        
//        layer.shadowOffset = CGSize(
//            width: 1.0,
//            height: 1.0
//        )
//        
//        self.contentMode = .scaleAspectFit
//    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = bounds.midX
    }
}
