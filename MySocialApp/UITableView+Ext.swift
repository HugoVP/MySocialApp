//
//  UITableView+Ext.swift
//  MySocialApp
//
//  Created by Hugo on 03/08/17.
//  Copyright © 2017 Hugo. All rights reserved.
//

import UIKit

extension UITableViewCell: ReusableView {}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: T.reuseIdentifier,
            for: indexPath as IndexPath
        ) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
}
