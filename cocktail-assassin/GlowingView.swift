//
//  GlowingView.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 2/3/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit
import PromiseKit

let π  = CGFloat(M_PI) // woot

class GlowingView: UIView {
    let GLOW_VIEW_DIAMETER : CGFloat = 600
    let imageView, glowView : UIImageView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        var zeroFrame = frame;
        zeroFrame.origin = CGPointZero
        
        glowView = UIImageView(frame: zeroFrame)
        imageView = UIImageView(frame: zeroFrame)
        
        super.init(frame: frame)
        
        glowView.contentMode = .ScaleAspectFit
        imageView.contentMode = .ScaleAspectFit
        glowView.image = UIImage(named: "glow.png")
        glowView.frame = CGRectMake((frame.width - GLOW_VIEW_DIAMETER)/2, (frame.height - GLOW_VIEW_DIAMETER)/2, GLOW_VIEW_DIAMETER, GLOW_VIEW_DIAMETER)        
        glowView.contentMode = .ScaleAspectFit
        glowView.alpha = 0
        
        addSubview(glowView)
        addSubview(imageView)
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
    func animate(duration: Double) -> Promise<Bool> {
        return when([fadeInGlow(duration * 0.2), spinGlowView(duration)])
            .then { (results) -> Promise<Bool> in
                return Promise<Bool>(true)
            }
    }
    
    func fadeInGlow(duration: Double) -> Promise<Bool> {
        return glowView.fadeIn(duration * 0.3, options: UIViewAnimationOptions.CurveLinear)
    }
    
    func spinGlowView(duration: Double) -> Promise<Bool> {
        return UIView.transition(self,
            duration: duration,
            options:  UIViewAnimationOptions.CurveLinear,
            animations: {
                self.glowView.transform = CGAffineTransformRotate(self.glowView.transform, 1/2 * π)
                return
        })
    }
    
    
}
