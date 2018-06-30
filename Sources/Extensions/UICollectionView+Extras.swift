//
//  UICollectionView+Extras.swift
//  Yahtzee
//
//  Created by Clay Ellis on 6/6/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

extension UICollectionView {
    open func register<T>(_ cellClass: T.Type) where T: UICollectionViewCell {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    open func dequeueReusableCell<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T where T: UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
