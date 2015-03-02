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
    class func transition(view: UIView, duration: NSTimeInterval, options: UIViewAnimationOptions, animations: () -> Void) -> Promise<Bool> {
        return Promise { deferred in
            self.transitionWithView(view, duration: duration, options: options, animations: animations, completion: deferred.fulfill)
        }
    }
    
    func fadeIn(duration: NSTimeInterval, options: UIViewAnimationOptions) -> Promise<Bool> {
        return UIView.transition(self, duration: duration, options: options, animations: {
            self.alpha = 1
        })
    }

}
