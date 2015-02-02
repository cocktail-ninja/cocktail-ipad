//
//  DrinkDetailsViewController.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 1/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit

class DrinkDetailsViewController: UIViewController {
    let drinkImageView = UIImageView(),
        backButton = UIButton.buttonWithType(UIButtonType.System) as UIButton

    var dismissDelegate : ViewControllerDismissDelegate?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(drink: Drink) {
        super.init()
        
        drinkImageView.frame = Constants.drinkFrames.expandedFrame
        drinkImageView.contentMode = .ScaleAspectFit
        drinkImageView.image = UIImage(named: drink.image)
        
        backButton.setTitle("〈", forState: .Normal)
        backButton.titleLabel?.font = UIFont.systemFontOfSize(40)
        backButton.frame = CGRectMake(30, 80, 100, 60)
        
        backButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(drinkImageView)
        
        view.addSubview(backButton)
    }
    
    func dismiss(){
        dismissViewControllerAnimated(false, completion: { complete in
            println("dismissed")
            self.dismissDelegate?.onViewControllerDismiss()
        })
    }
}