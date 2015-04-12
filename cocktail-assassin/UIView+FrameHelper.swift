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
    func scaleFrame(scale: CGFloat) {
        self.frame.size.height *= scale
        self.frame.size.width *= scale
    }
    
    func setOriginX(originX: CGFloat){
        self.frame.origin.x = originX
    }
    
    func setOriginY(originY: CGFloat){
        self.frame.origin.y = originY
    }
    
    func setBorder(width: CGFloat, color: CGColor = UIColor.blackColor().CGColor, radius:CGFloat = 0.0){
        self.layer.borderWidth = width
        self.layer.borderColor = color
        self.layer.cornerRadius = radius
    }
    
    func setBorder(color: CGColor = UIColor.blackColor().CGColor){
        self.layer.borderColor = color
    }
    
    func placeAtCenter(view: UIView){
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
    }
}
