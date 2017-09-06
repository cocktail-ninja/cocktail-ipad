//
//  LoadingViewController.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 24/10/15.
//  Copyright © 2015 tw. All rights reserved.
//

import UIKit
import MONActivityIndicatorView

class LoadingViewControler: UIViewController {
    
    var coreDataStack: CoreDataStack!
    @IBOutlet var loadingIndicator: MONActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.numberOfCircles = 5
        loadingIndicator.radius = 6
        loadingIndicator.internalSpacing = 15
        loadingIndicator.duration = 0.5
        loadingIndicator.delay = 0.1
        loadingIndicator.startAnimating()
        loadingIndicator.center = view.center
    }
    
    func showDrinks() {
        performSegue(withIdentifier: "Drinks", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DrinksViewController
        destination.coreDataStack = coreDataStack
        super.prepare(for: segue, sender: sender)
    }
    
}
