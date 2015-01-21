//
//  MainViewController.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 20/1/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        var drinksVC = DrinksViewController()
        presentModalViewController(drinksVC, animated: false)
    }
}
