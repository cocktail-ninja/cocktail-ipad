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

class DrinksViewController: UIViewController {
    
    var coreDataStack: CoreDataStack!
    
    @IBOutlet fileprivate var carousel: iCarousel!
    @IBOutlet fileprivate var pageControl: UIPageControl!
    @IBOutlet fileprivate var drinkViewTemplate: UIView!
    @IBOutlet fileprivate var adminButton: UIButton!
    
    fileprivate var selectedDrinkIndex = 0
    fileprivate var items: [Drink] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        items = Drink.allDrinks(coreDataStack.context)
        pageControl.numberOfPages = items.count
        carousel.currentItemIndex = selectedDrinkIndex
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carousel.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        carousel.type = .custom
        carousel.dataSource = self
        carousel.delegate = self
        carousel.centerItemWhenSelected = false
        
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.4)
        pageControl.addTarget(self, action: #selector(DrinksViewController.pageControlChanged), for: .valueChanged)
        carouselCurrentItemIndexDidChange(carousel)
    }
    
    @IBAction func pageControlChanged() {
        carousel.scrollToItem(at: pageControl.currentPage, animated: true)
    }
    
    @IBAction func adminClicked() {
        self.navigationController?.pushViewController(adminMenuOrLoginController(), animated: true)
    }
    
    fileprivate func adminMenuOrLoginController() -> UIViewController {        
        if AdminService.sharedInstance.isAdmin {
            return AdminViewController(coreDataStack: coreDataStack)
        } else {
            return AdminPasswordController(coreDataStack: coreDataStack)
        }
    }
}

extension DrinksViewController: ASFSharedViewTransitionDataSource {
    
    func sharedView() -> UIView! {
        let drinkView = carousel.itemView(at: self.selectedDrinkIndex)! as! DrinkView
        return drinkView.imageView
    }
}

extension DrinksViewController: iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count + 1
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        pageControl.currentPage = carousel.currentItemIndex
    }
}

extension DrinksViewController: iCarouselDelegate {
    
    func carousel(_ _: iCarousel, didSelectItemAt index: Int) {
        var drink: Drink
        if index == items.count {
            drink = Drink.newDrink("", imageName: "add-drink", editable: true, managedContext: coreDataStack.context)
        } else {
            drink = self.items[index]
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let drinkDetailsVC = storyboard.instantiateViewController(withIdentifier: "DrinkDetails") as! DrinkDetailsViewController
        drinkDetailsVC.drink = drink
        drinkDetailsVC.imageSize = drinkViewTemplate.frame.size
        drinkDetailsVC.coreDataStack = coreDataStack
        if index == items.count {
            drinkDetailsVC.editMode = true
        }
        self.selectedDrinkIndex = index
        self.navigationController?.pushViewController(drinkDetailsVC, animated: true)
    }
    
    func carousel(_ carousel: iCarousel, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
        let scale: CGFloat = DrinkCarouselTransformation.getScale(offset)
        let xOffset: CGFloat = DrinkCarouselTransformation.getXOffset(offset, carouselItemWidth: carousel.itemWidth)
        return CATransform3DScale(
            CATransform3DTranslate(transform, xOffset, 0, 0),
            scale,
            scale,
            1
        )
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .wrap:
            return 1
        case .showBackfaces:
            return 0
        default:
            return value
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
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
    
    class func getScale(_ offset: CGFloat) -> CGFloat {
        return max(1 - pow(offset * 0.3, 2), 0.3)
    }
    
    class func getXOffset(_ offset: CGFloat, carouselItemWidth: CGFloat) -> CGFloat {
        if offset < -3 || offset > 3 {
            return offset * carouselItemWidth
        } else {
            let scaleOffset = -offset * (max(0, (abs(offset) - 1)) * 25)
            return offset * carouselItemWidth + scaleOffset
        }
    }
}
