//
//  Constants.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 2/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//
import UIKit

struct Constants {
    struct drinkFrames {
        static let basicFrame = CGRectMake(387, 134, 250, 500)
        static let expandedFrame = CGRectMake(80, 94, 320, 640)
    }
    
    struct baseUrl {
        static let dev = "http://private-4b044-cocktailninja.apiary-mock.com"
        static let prod = "http://192.168.240.1/arduino"
    }
}

struct ThemeColor {
    static let primary = UIColor(red: 0/255, green: 187/255, blue: 205/255, alpha: 1)
}