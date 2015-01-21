//
//  DrinksViewController.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 21/1/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit
import QuartzCore

class DrinksViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    var items = [
        Drink(name : "name", image : "cocktail-1"),
        Drink(name : "name2", image : "cocktail-2"),
        Drink(name : "name3", image : "cocktail-3"),
        Drink(name : "name4", image : "cocktail-4"),
        Drink(name : "name5", image : "cocktail-5")
    ];

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        var carousel = iCarousel(frame: view.frame)
        carousel.type = .Custom
        carousel.dataSource = self
        carousel.delegate = self

        view.addSubview(carousel)
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return items.count
    }
    
    func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int){
        NSLog("Select: \(index)");
    }
    
    func carousel(carousel: iCarousel!, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
        var scale : CGFloat = max(1 - powf((offset * 0.4), 2.0), 0.4)
        return
            CATransform3DScale(
                CATransform3DTranslate(transform, offset * carousel.itemWidth, 0, 0),
                scale,
                scale,
                1
            )
    }

    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .Wrap:
            return 1
        default:
            return value
        }
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView! {
        var drink = items[index]
        
        if (view == nil) {
            view = UIImageView(frame:CGRectMake(0, 0, 250, 450))
            view.contentMode = .ScaleAspectFit
        }
        
        (view as UIImageView).image = UIImage(named: drink.image)
        return view
    }
}
