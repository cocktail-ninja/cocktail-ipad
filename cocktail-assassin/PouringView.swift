//
//  PouringView.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 2/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit
import PromiseKit

class PouringView: UIView {
    let TINT_COLOR : UIColor = UIColor(white: 0.8, alpha: 1.0)
    let bwImageView, imageView : UIImageView
    let bwImageContainer : UIView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        var zeroFrame = frame;
        zeroFrame.origin = CGPointZero
        bwImageView = UIImageView(frame: zeroFrame)
        imageView = UIImageView(frame: zeroFrame)
        bwImageContainer = UIView(frame: zeroFrame)
        
        super.init(frame: frame)
        
        imageView.contentMode = .ScaleAspectFit
        bwImageView.contentMode = .ScaleAspectFit
        bwImageContainer.clipsToBounds = true
        bwImageContainer.alpha = 0
        bwImageContainer.addSubview(bwImageView)
        
        addSubview(imageView)
        addSubview(bwImageContainer)
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
        bwImageView.image = image.toGrayscale(TINT_COLOR)
    }
    
    
    func animate(duration: Double) -> Promise<Bool> {
        return bwImageContainer.fadeIn(0.2,  options: UIViewAnimationOptions.CurveLinear)
            .then { (completed) -> Promise<Bool> in
                return UIView.transition(self,
                            duration: duration,
                            options:  UIViewAnimationOptions.CurveLinear,
                            animations: {
                                self.bwImageContainer.frame.size.height = 0
                        })
            }
    }
    
    
}
