//
//  NSLayoutConstraint+Copy.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 24/10/15.
//  Copyright © 2015 tw. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    func copyConstraintsFromView(_ sourceView: UIView, toView destView: UIView) {
        for constraint in sourceView.superview!.constraints {
            if constraint.firstItem as? NSObject == sourceView {
                let newConstraint = NSLayoutConstraint(
                    item: destView,
                    attribute: constraint.firstAttribute,
                    relatedBy: constraint.relation,
                    toItem: constraint.secondItem,
                    attribute: constraint.secondAttribute,
                    multiplier: constraint.multiplier,
                    constant: constraint.constant
                )
                sourceView.superview!.addConstraint(newConstraint)
            }
            else if constraint.secondItem as? NSObject == sourceView {
                let newConstraint = NSLayoutConstraint(
                    item: constraint.firstItem,
                    attribute: constraint.firstAttribute,
                    relatedBy: constraint.relation,
                    toItem: destView,
                    attribute: constraint.secondAttribute,
                    multiplier: constraint.multiplier,
                    constant: constraint.constant
                )
                sourceView.superview!.addConstraint(newConstraint)
            }
        }
    }
    
}
