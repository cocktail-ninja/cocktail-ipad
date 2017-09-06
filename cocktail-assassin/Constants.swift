//
//  Constants.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 2/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//
import UIKit

struct Constants {
    
    // TODO: remove these after they're removed from the pouring drink view.
    struct drinkFrames {
        static let basicFrame = CGRect(x: 387, y: 134, width: 250, height: 500)
        static let expandedFrame = CGRect(x: 80, y: 94, width: 320, height: 640)
    }
    
    struct baseUrl {
        static let dev = "http://private-4b044-cocktailninja.apiary-mock.com"
        static let prod = "http://192.168.240.1/arduino"
    }
}

struct ThemeColor {
    static let primary = UIColor(red: 0/255, green: 187/255, blue: 205/255, alpha: 1) // 00BBCD
    static let highlighted = UIColor(red: 24/255, green: 112/255, blue: 122/255, alpha: 1)
    static let disabled = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
    static let error = UIColor.red
}
