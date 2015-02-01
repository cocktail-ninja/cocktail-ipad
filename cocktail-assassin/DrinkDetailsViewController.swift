//
//  DrinkDetailsViewController.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 1/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit

class DrinkDetailsViewController: UIViewController {
    var pouringView: PouringView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
    
        var viewportWidth = view.frame.width,
            viewportHeight = view.frame.height;
        
        pouringView = PouringView(frame: {
            let viewWidth : CGFloat = 250,
                viewHeight : CGFloat = 500;
            return CGRectMake((viewportWidth - viewWidth)/2,
                    (viewportHeight - viewHeight)/2,
                    viewWidth,
                    viewHeight);
        }())
        
        
        pouringView.setImage(UIImage(named: "cocktail-2")!)
        
        view.addSubview(pouringView)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        pouringView.animate(4.2, onComplete: { () -> Void in
            println("completed!")
        })
    }
}