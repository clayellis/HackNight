//
//  UIView+Extras.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

extension UIView {

    func addAutoLayoutSubview(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
    }

    func fill(_ viewToFill: UIView, withPriority priority: UILayoutPriority = .required) {
        let left = leftAnchor.constraint(equalTo: viewToFill.leftAnchor)
        let right = rightAnchor.constraint(equalTo: viewToFill.rightAnchor)
        let top = topAnchor.constraint(equalTo: viewToFill.topAnchor)
        let bottom = bottomAnchor.constraint(equalTo: viewToFill.bottomAnchor)

        let constraints = [left, right, top, bottom]

        constraints.forEach { $0.priority = priority }

        NSLayoutConstraint.activate(constraints)
    }

    func fill(_ layoutGuideToFill: UILayoutGuide, withPriority priority: UILayoutPriority = .required) {
        let left = leftAnchor.constraint(equalTo: layoutGuideToFill.leftAnchor)
        let right = rightAnchor.constraint(equalTo: layoutGuideToFill.rightAnchor)
        let top = topAnchor.constraint(equalTo: layoutGuideToFill.topAnchor)
        let bottom = bottomAnchor.constraint(equalTo: layoutGuideToFill.bottomAnchor)

        let constraints = [left, right, top, bottom]

        constraints.forEach { $0.priority = priority }

        NSLayoutConstraint.activate(constraints)
    }

}

extension UIView {
    public var allSubviews: [UIView] {
        var all = subviews
        for subview in all {
            all.append(contentsOf: subview.allSubviews)
        }
        return all
    }

    public func subviewWithClassName(_ className: String) -> UIView? {
        return allSubviews.first { type(of: $0).description() == className }
    }

    public func subviewsWithClassName(_ className: String) -> [UIView] {
        return allSubviews.filter { type(of: $0).description() == className }
    }

    public func subviewWithClassType<T>(_ classType: T.Type) -> T? {
        return allSubviews.first { $0 is T } as? T
    }

    public func subviewsWithClassType<T>(_ classType: T.Type) -> [T] {
        return allSubviews.compactMap { $0 as? T }
    }

    public func indexOfSubview(_ subview: UIView) -> Int? {
        return subviews.index(of: subview)
    }
}
