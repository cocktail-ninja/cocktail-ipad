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
    private var pageControl = UIPageControl();
    
    var basicImageFrame = CGRectMake(387, 134, 250, 500)
    
    private var items = [
        Drink(name : "Angry Cocoa", image : "cocktail-4"),
        Drink(name : "Apricot Lemon Boot", image : "cocktail-5"),
        Drink(name : "Arctic Shake", image : "cocktail-1"),
        Drink(name : "Doomed Mix", image : "cocktail-2"),
        Drink(name : "Famous Desert Ocean", image : "cocktail-3"),
        Drink(name : "Gambler's Murder", image : "cocktail-4"),
        Drink(name : "Indefinite Desert Buster", image : "cocktail-5"),
        Drink(name : "Insane Stout Martini", image : "cocktail-1"),
        Drink(name : "Kiwi Blueberry", image : "cocktail-2"),
        Drink(name : "Nasty Coconut", image : "cocktail-3"),
        Drink(name : "Negative Drunken Mountain", image : "cocktail-4"),
        Drink(name : "Peppermint Mint Chaos", image : "cocktail-5"),
        Drink(name : "Pleasant Green", image : "cocktail-1"),
        Drink(name : "Plum Abyss", image : "cocktail-2"),
        Drink(name : "Random Royal Deep", image : "cocktail-3"),
        Drink(name : "Rocky Pretender", image : "cocktail-4"),
        Drink(name : "Sour Ecstacy", image : "cocktail-5"),
        Drink(name : "Ultimate Ochre Dirt", image : "cocktail-1"),
        Drink(name : "Unholy Schnapps Twister", image : "cocktail-2"),
        Drink(name : "Vanilla Punch", image : "cocktail-3")
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()

        carousel.frame = view.frame
        carousel.type = .Custom
        carousel.dataSource = self
        carousel.delegate = self
        carousel.centerItemWhenSelected = false
        self.view.addSubview(carousel)
        
        pageControl.numberOfPages = items.count
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.4)

        pageControl.frame = {
            let viewHeight : CGFloat = 20,
                bottomPadding : CGFloat = 20,
                originY : CGFloat = self.view.frame.height - viewHeight - bottomPadding;
            return CGRectMake(0, originY, self.view.frame.size.width, viewHeight)
        }()
        
        carousel.addSubview(pageControl);
        
        carousel.currentItemIndex = items.count / 2
        carouselCurrentItemIndexDidChange(carousel);
    }
    
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return items.count
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel!){
        pageControl.currentPage = carousel.currentItemIndex;
    }
    
    
    func carousel(carousel: iCarousel!, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
        var scale : CGFloat = max(1 - pow(offset * 0.3, 2), 0.3)
        var xOffset : CGFloat = {
            if (offset < -3 || offset > 3) {
                return offset * carousel.itemWidth
            } else {
                var scaleOffset = -offset * (max(0, (abs(offset) - 1)) * 25)
                return offset * carousel.itemWidth + scaleOffset
            }

        }()
        
        return
            CATransform3DScale(
                CATransform3DTranslate(transform, xOffset, 0, 0),
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
        if (view == nil) {
            view = DrinkCarouselItem(frame: basicImageFrame)
        }
        
        (view as DrinkCarouselItem).setDrink(items[index])
        return view
    }
}
