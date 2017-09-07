//
//  UIView+Promise.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 2/3/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit
import PromiseKit

extension UIView {
    
    class func transition(_ view: UIView,
                          duration: TimeInterval,
                          options: UIViewAnimationOptions,
                          animations: @escaping () -> Void) -> Promise<Bool> {
        return Promise { fulfill, _ in
            self.transition(with: view, duration: duration, options: options, animations: animations, completion: fulfill)
        }
    }
    
    func fadeIn(_ duration: TimeInterval, options: UIViewAnimationOptions) -> Promise<Bool> {
        return UIView.transition(self, duration: duration, options: options, animations: {
            self.alpha = 1
        })
    }

}
