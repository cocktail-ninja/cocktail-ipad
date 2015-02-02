//
//  UIView+FrameHelper.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 2/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//


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
    
    func setBorder(width: CGFloat, color: CGColor = UIColor.blackColor().CGColor){
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }
}
