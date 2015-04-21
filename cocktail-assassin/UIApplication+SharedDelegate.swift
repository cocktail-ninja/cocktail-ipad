//
//  UIApplication+SharedDelegate.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 17/3/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit

extension UIApplication {
    class func sharedDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}
