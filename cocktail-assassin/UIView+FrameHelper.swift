//
//  UIView+FrameHelper.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 2/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit
import QuartzCore

extension UIView {
    
    func scaleFrame(_ scale: CGFloat) {
        self.frame.size.height *= scale
        self.frame.size.width *= scale
    }
    
    func setOriginX(_ originX: CGFloat) {
        self.frame.origin.x = originX
    }
    
    func setOriginY(_ originY: CGFloat) {
        self.frame.origin.y = originY
    }
    
    func setBorder(_ width: CGFloat, color: CGColor = UIColor.black.cgColor, radius: CGFloat = 0.0) {
        self.layer.borderWidth = width
        self.layer.borderColor = color
        self.layer.cornerRadius = radius
    }
    
    func setBorder(_ color: CGColor = UIColor.black.cgColor) {
        self.layer.borderColor = color
    }
    
    func placeAtCenter(_ view: UIView) {
        self.addConstraint(NSLayoutConstraint(
            item: view,
            attribute: NSLayoutAttribute.centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.centerX,
            multiplier: 1,
            constant: 0)
        )
        self.addConstraint(NSLayoutConstraint(
            item: view,
            attribute: NSLayoutAttribute.centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.centerY,
            multiplier: 1,
            constant: 0)
        )
    }
}
