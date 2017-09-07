//
//  UIStoryboard.swift
//  cocktail-assassin
//
//  Created by Col Harris on 07/09/2017.
//  Copyright © 2017 tw. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    func initView<T: UIViewController>(withId: String) -> T? {
        return self.instantiateViewController(withIdentifier: "IngredientMappingViewController") as? T
    }
    
}
