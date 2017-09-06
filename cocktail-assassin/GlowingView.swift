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
        zeroFrame.origin = CGPoint.zero
        
        glowView = UIImageView(frame: zeroFrame)
        imageView = UIImageView(frame: zeroFrame)
        
        super.init(frame: frame)
        
        glowView.contentMode = .scaleAspectFit
        imageView.contentMode = .scaleAspectFit
        glowView.image = UIImage(named: "glow.png")
        glowView.frame = CGRect(x: (frame.width - GLOW_VIEW_DIAMETER)/2, y: (frame.height - GLOW_VIEW_DIAMETER)/2, width: GLOW_VIEW_DIAMETER, height: GLOW_VIEW_DIAMETER)        
        glowView.contentMode = .scaleAspectFit
        glowView.alpha = 0
        
        addSubview(glowView)
        addSubview(imageView)
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func animate(_ duration: Double) -> Promise<Bool> {
        return firstly {
            when(fulfilled: fadeInGlow(duration * 0.2), spinGlowView(duration))
        }.then { (_, _) -> Promise<Bool> in
            return Promise(value: true)
        }
    }
    
    func fadeInGlow(_ duration: Double) -> Promise<Bool> {
        return glowView.fadeIn(duration * 0.3, options: UIViewAnimationOptions.curveLinear)
    }
    
    func spinGlowView(_ duration: Double) -> Promise<Bool> {
        return UIView.transition(self,
            duration: duration,
            options:  UIViewAnimationOptions.curveLinear,
            animations: {
                self.glowView.transform = self.glowView.transform.rotated(by: 1/2 * π)
                return
        })
    }
    
}
