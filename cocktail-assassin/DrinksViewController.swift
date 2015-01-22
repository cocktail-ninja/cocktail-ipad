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
    private var carousel = iCarousel()
    private var selectedDrink =  UIImageView()
    var basicImageFrame = CGRectMake(387, 134, 250, 500)
    var expandedImageFrame = CGRectMake(30, 34, 350, 700)
    
    
    private var items = [
        Drink(name : "name", image : "cocktail-1"),
        Drink(name : "name2", image : "cocktail-2"),
        Drink(name : "name3", image : "cocktail-3"),
        Drink(name : "name4", image : "cocktail-4"),
        Drink(name : "name5", image : "cocktail-5")
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()

        carousel.frame = view.frame
        carousel.type = .Custom
        carousel.dataSource = self
        carousel.delegate = self
        carousel.centerItemWhenSelected = false
        
        view.addSubview(carousel)
        
        let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(900, 50, 100, 50)
        button.setTitle("X", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        button.tag = 42
        button.alpha = 0
        
        self.view.addSubview(button)
    }
    
    func buttonAction(sender:UIButton!) {
        self.view.viewWithTag(42)?.alpha = 0
        UIView.transitionWithView(self.view,
            duration: 0.2,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.selectedDrink.frame = self.basicImageFrame

            }, completion: {(finished: Bool) in
                UIView.transitionWithView(self.view,
                    duration: 0.1,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: {
                        self.carousel.alpha = 1
                    }, completion: {(finished: Bool) in
                        self.selectedDrink.frame = CGRectZero
                })
                
        })
        
        
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return items.count
    }
    
    func carousel(theCarousel: iCarousel!, didSelectItemAtIndex index: Int){
        selectedDrink.image = UIImage(named: items[index].image)
        
        selectedDrink.contentMode = .ScaleAspectFit
        selectedDrink.frame = basicImageFrame
        
        
        var offset = CGFloat((index - theCarousel.currentItemIndex) % self.items.count)
        if (index - theCarousel.currentItemIndex > theCarousel.currentItemIndex + (self.items.count / 2)) {
            offset = CGFloat((index - theCarousel.currentItemIndex) % self.items.count - self.items.count)
        }
        
        var scale : CGFloat = max(1 - pow(offset * 0.4, 2.0), 0.4)
        
        selectedDrink.frame.size.width *= scale
        selectedDrink.frame.size.height *= scale
        

        selectedDrink.frame.origin.x = (view.frame.size.width - selectedDrink.frame.size.width) / 2 + offset * theCarousel.itemWidth
        selectedDrink.frame.origin.y = (view.frame.size.height - selectedDrink.frame.size.height) / 2
    

        theCarousel.itemViewAtIndex(index).hidden = true


        view.addSubview(selectedDrink)
        UIView.transitionWithView(self.view,
            duration: 0.3,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.selectedDrink.frame = self.expandedImageFrame
            }, completion: nil)
        
        UIView.transitionWithView(self.view,
            duration: 0.1,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                theCarousel.alpha = 0
                self.view.viewWithTag(42)?.alpha = 1
            }, completion: { (finished: Bool) in
                theCarousel.itemViewAtIndex(index).hidden = false
                self.carousel.scrollToItemAtIndex(index, animated: false)
        })
        
        
    }
    
    func carousel(carousel: iCarousel!, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
        var scale : CGFloat = max(1 - pow(offset * 0.4, 2), 0.4)
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
            view = UIImageView(frame: basicImageFrame)
            view.contentMode = .ScaleAspectFit
        }
        
        (view as UIImageView).image = UIImage(named: drink.image)
        return view
    }
}
