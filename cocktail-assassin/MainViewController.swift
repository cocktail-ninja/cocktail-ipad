//
//  MainViewController.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 20/1/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit
import iOSSharedViewTransition

class MainViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var navVC = UINavigationController(rootViewController: DrinksViewController())
        
        
        navVC.navigationBarHidden = true;
        
        ASFSharedViewTransition.addTransitionWithFromViewControllerClass(DrinksViewController.self,
            toViewControllerClass: DrinkDetailsViewController.self,
            withNavigationController: navVC,
            withDuration: 0.5)
        ASFSharedViewTransition.addTransitionWithFromViewControllerClass(DrinkDetailsViewController.self,
            toViewControllerClass: PouringViewController.self,
            withNavigationController: navVC,
            withDuration: 0.8)
        ASFSharedViewTransition.addTransitionWithFromViewControllerClass(PouringViewController.self,
            toViewControllerClass: DrinksViewController.self,
            withNavigationController: navVC,
            withDuration: 0.5)
        
        presentViewController(navVC, animated: false, completion: nil)
    }
}
