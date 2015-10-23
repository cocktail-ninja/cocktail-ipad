//
//  CGRect+Transform.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 23/10/15.
//  Copyright © 2015 tw. All rights reserved.
//

import UIKit

extension CGRect {
    
    static func transform(rect: CGRect, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(
            x: rect.origin.x + x,
            y: rect.origin.y + y,
            width: rect.size.width + width,
            height: rect.size.height + height
        )
    }
    
    func transform(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect.transform(self, x: x, y: y, width: width, height: height)
    }
    
}