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
    
    var coreDataStack: CoreDataStack!
    
    @IBOutlet private var carousel: iCarousel!
    @IBOutlet private var pageControl: UIPageControl!
    @IBOutlet private var drinkViewTemplate: UIView!
    @IBOutlet private var adminButton: UIButton!
    
    private var selectedDrinkIndex = 0
    private var items:[Drink] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        items = Drink.allDrinks(coreDataStack.context)
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
        
        carousel.type = .Custom
        carousel.dataSource = self
        carousel.delegate = self
        carousel.centerItemWhenSelected = false
        
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.4)
        pageControl.addTarget(self, action: "pageControlChanged", forControlEvents: .ValueChanged)
        carouselCurrentItemIndexDidChange(carousel)
    }
    
    @IBAction func pageControlChanged() {
        carousel.scrollToItemAtIndex(pageControl.currentPage, animated: true)
    }
    
    @IBAction func adminClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("AdminViewController") as! AdminViewController
        controller.coreDataStack = coreDataStack
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func sharedView() -> UIView! {
        let drinkView = carousel.itemViewAtIndex(self.selectedDrinkIndex)! as! DrinkView
        return drinkView.imageView
    }
    
    // MARK: iCarousel Delegate Methods
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return items.count + 1
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        pageControl.currentPage = carousel.currentItemIndex
    }
    
    func carousel(_carousel: iCarousel, didSelectItemAtIndex index: Int) {
        var drink: Drink
        if( index == items.count ) {
            drink = Drink.newDrink("", imageName: "add-drink", editable: true, managedContext: coreDataStack.context)
        } else {
            drink = self.items[index]
        }
        
        let drinkDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DrinkDetails") as! DrinkDetailsViewController
        drinkDetailsVC.drink = drink
        drinkDetailsVC.imageSize = drinkViewTemplate.frame.size
        drinkDetailsVC.coreDataStack = coreDataStack
        if( index == items.count ) {
            drinkDetailsVC.editMode = true
        }
        self.selectedDrinkIndex = index
        self.navigationController?.pushViewController(drinkDetailsVC, animated: true)
    }
    
    func carousel(carousel: iCarousel, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
        let scale : CGFloat = DrinkCarouselTransformation.getScale(offset)
        let xOffset : CGFloat = DrinkCarouselTransformation.getXOffset(offset, carouselItemWidth: carousel.itemWidth)
        return
            CATransform3DScale(
                CATransform3DTranslate(transform, xOffset, 0, 0),
                scale,
                scale,
                1
            )
    }

    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .Wrap:
            return 1
        case .ShowBackfaces:
            return 0    
        default:
            return value
        }
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let theView = view as? DrinkView ?? DrinkView(frame: drinkViewTemplate.frame)
        if index == items.count {
            theView.displayAddDrink()
        } else {
            theView.displayDrink(items[index])
        }
        return theView
    }

}

class DrinkCarouselTransformation {
    class func getScale(offset: CGFloat) -> CGFloat {
        return max(1 - pow(offset * 0.3, 2), 0.3)
    }
    
    class func getXOffset(offset: CGFloat, carouselItemWidth: CGFloat) -> CGFloat {
        if (offset < -3 || offset > 3) {
            return offset * carouselItemWidth
        } else {
            let scaleOffset = -offset * (max(0, (abs(offset) - 1)) * 25)
            return offset * carouselItemWidth + scaleOffset
        }
    }
}
