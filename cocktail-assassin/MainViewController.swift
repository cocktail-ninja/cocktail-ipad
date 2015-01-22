//
//  MainViewController.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 20/1/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        var drinksVC = DrinksViewController()
        presentViewController(drinksVC, animated: false, completion: nil)
    }
}
