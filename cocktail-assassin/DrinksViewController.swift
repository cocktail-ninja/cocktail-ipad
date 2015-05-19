//
//  DrinksViewController.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 21/1/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData
import iCarousel
import PromiseKit
import iOSSharedViewTransition

class DrinksViewController: UIViewController, iCarouselDataSource, iCarouselDelegate, ASFSharedViewTransitionDataSource {
    private var carousel = iCarousel()
    private var pageControl = UIPageControl()
    private var selectedDrinkIndex = 0

    lazy var managedContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()
    
    var items:[Drink] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        items = Drink.allDrinks(managedContext!)
        if(items.count == 0){
            DrinkService.initDatabase(managedContext!)
            items = Drink.allDrinks(managedContext!)
        }
        
        pageControl.numberOfPages = items.count
        carousel.currentItemIndex = selectedDrinkIndex
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        carousel.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        carousel.frame = view.frame
        carousel.type = .Custom
        carousel.dataSource = self
        carousel.delegate = self
        carousel.centerItemWhenSelected = false
        view.addSubview(carousel)
        
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.4)

        pageControl.frame = {
            let viewHeight : CGFloat = 20,
                bottomPadding : CGFloat = 20,
                originY : CGFloat = self.view.frame.height - viewHeight - bottomPadding;
            return CGRectMake(0, originY, self.view.frame.size.width, viewHeight)
        }()
        
        carousel.addSubview(pageControl)
        carouselCurrentItemIndexDidChange(carousel)
    }
    
    func sharedView() -> UIView! {
        return (carousel.itemViewAtIndex(self.selectedDrinkIndex)! as! DrinkView).imageView
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return items.count + 1
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel!){
        pageControl.currentPage = carousel.currentItemIndex
    }
    
    func carousel(_carousel: iCarousel!, didSelectItemAtIndex index: Int) {
        var drink: Drink
        if( index == items.count ) {
            drink = Drink.newDrink("New Drink", imageName: "add-drink", editable: true, managedContext: managedContext!)
        } else {
            drink = self.items[index]
        }
        
        var drinkDetailsVC = DrinkDetailsViewController(drink: drink)
        if( index == items.count ) {
            drinkDetailsVC.edit()
        }
        self.selectedDrinkIndex = index
        self.navigationController?.pushViewController(drinkDetailsVC, animated: true)
    }
    
    func carousel(carousel: iCarousel!, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
        var scale : CGFloat = DrinkCarouselTransformation.getScale(offset)
        var xOffset : CGFloat = DrinkCarouselTransformation.getXOffset(offset, carouselItemWidth: carousel.itemWidth)
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
        case .ShowBackfaces:
            return 0    
        default:
            return value
        }
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
        var theView = view as? DrinkView;
        if theView == nil {
            theView = DrinkView(frame: Constants.drinkFrames.basicFrame)
        }
        if( index == items.count ) {
            theView?.displayAddDrink()
        } else {
            theView?.displayDrink(items[index])
        }
        return theView
    }
}
