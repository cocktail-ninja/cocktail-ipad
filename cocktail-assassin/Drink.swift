//
//  Drink.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 21/1/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit

class Drink: NSObject {
    var name : NSString, image : NSString
    
    init(name : NSString, image : NSString) {
        self.name = name
        self.image = image
    }
}
