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
    let bwImageView, imageView: UIImageView
    let bwImageContainer: UIView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        var zeroFrame = frame
        zeroFrame.origin = CGPoint.zero
        bwImageView = UIImageView(frame: zeroFrame)
        imageView = UIImageView(frame: zeroFrame)
        bwImageContainer = UIView(frame: zeroFrame)
        
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFit
        bwImageView.contentMode = .scaleAspectFit
        bwImageContainer.clipsToBounds = true
        bwImageContainer.alpha = 0
        bwImageContainer.addSubview(bwImageView)
        
        addSubview(imageView)
        addSubview(bwImageContainer)
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
        bwImageView.image = image.toGrayscale(UIColor(white: 0.8, alpha: 1.0))
    }
    
    func animate(_ duration: Double) -> Promise<Bool> {
        return firstly {
            bwImageContainer.fadeIn(0.2, options: UIViewAnimationOptions.curveLinear)
        }.then { _ -> Promise<Bool> in
            return UIView.transition(
                self,
                duration: duration,
                options: UIViewAnimationOptions.curveLinear,
                animations: {
                    self.bwImageContainer.frame.size.height = 0
                }
            )
        }
    }
    
}
