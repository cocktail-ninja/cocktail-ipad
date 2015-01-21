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
    var items = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyanColor()
        
        var carousel = iCarousel(frame: view.frame)
        carousel.type = .Custom
        carousel.dataSource = self
        carousel.delegate = self

        view.addSubview(carousel)
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return items.count
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

    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
{
        switch option {
        case .Wrap:
            return 1
        default:
            return value
        }
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView! {
        var label: UILabel! = nil
        
        if (view == nil) {
            view = UIView(frame:CGRectMake(0, 0, 320, 450))
            view.backgroundColor = UIColor.blueColor()

            label = UILabel(frame:view.bounds)
            label.textAlignment = .Center
            label.font = label.font.fontWithSize(50)
            label.tag = 1
            view.addSubview(label)
        } else {
            label = view.viewWithTag(1) as UILabel!
        }

        label.text = "\(items[index])"
        return view
    }
}
