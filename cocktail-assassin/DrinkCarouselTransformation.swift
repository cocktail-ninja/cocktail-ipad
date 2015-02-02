//
//  DrinkCarouselTransformationHelper.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 2/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//


class DrinkCarouselTransformation {
    class func getScale(offset: CGFloat) -> CGFloat {
        return max(1 - pow(offset * 0.3, 2), 0.3)
    }
    
    class func getXOffset(offset: CGFloat, carouselItemWidth: CGFloat) -> CGFloat {
        if (offset < -3 || offset > 3) {
            return offset * carouselItemWidth
        } else {
            var scaleOffset = -offset * (max(0, (abs(offset) - 1)) * 25)
            return offset * carouselItemWidth + scaleOffset
        }
    }
}
