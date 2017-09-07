//
//  Constants.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 2/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//
import UIKit

struct Constants {
    
    struct BaseUrl {
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
