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

    func initIngredients(){
        Ingredient.newIngredient("Light Rum", pumpNumber: 1, amountLeft: 100, managedContext: managedContext!)
        Ingredient.newIngredient("Vodka", pumpNumber: 2, amountLeft: 100, managedContext: managedContext!)
        Ingredient.newIngredient("Gin", pumpNumber: 3, amountLeft: 100, managedContext: managedContext!)
        Ingredient.newIngredient("Tequila", pumpNumber: 4, amountLeft: 50, managedContext: managedContext!)
        Ingredient.newIngredient("Triple Sec", pumpNumber: 5, amountLeft: 50, managedContext: managedContext!)
      
        Ingredient.newIngredient("Coca Cola", pumpNumber: 6, amountLeft: 400, managedContext: managedContext!)
        Ingredient.newIngredient("Lemonade", pumpNumber: 7, amountLeft: 500, managedContext: managedContext!)
        Ingredient.newIngredient("Orange Juice", pumpNumber: 8, amountLeft: 400, managedContext: managedContext!)
        Ingredient.newIngredient("Cranberry Juice", pumpNumber: 9, amountLeft: 500, managedContext: managedContext!)
        Ingredient.newIngredient("Lime Juice", pumpNumber: 10, amountLeft: 500, managedContext: managedContext!)
    }
    
    func createDrinkWithIngredient(name:String, imageName:String, ingredients: Dictionary<String, NSNumber>) -> Drink{
        var drink = Drink.newDrink(name, imageName: imageName, managedContext: managedContext!)
        
        for (ingredientName, amountNeeded) in ingredients{
            drink.addIngredient(Ingredient.getIngredient(ingredientName, managedContext: managedContext!)!, amount: amountNeeded)
        }
        return drink
    }
    
    func initDatabase() {
        initIngredients()
        items.append(createDrinkWithIngredient("Dirty Texas Tea",
            imageName: "dirty-texas-tea",
            ingredients: ["Vodka": 23, "Light Rum": 23, "Tequila": 23, "Triple Sec": 23, "Orange Juice": 45, "Coca Cola": 150]))
        
        items.append(createDrinkWithIngredient("Alpine Lemonade",
            imageName: "alpine-lemonade",
            ingredients: ["Vodka": 30, "Gin": 30, "Light Rum": 30, "Lemonade": 60, "Cranberry Juice": 60]))
        
        items.append(createDrinkWithIngredient("The Ollie",
            imageName: "the-ollie",
            ingredients: ["Vodka": 60, "Light Rum": 30, "Tequila": 30, "Lemonade": 150]))
        
        items.append(createDrinkWithIngredient("Cosmopolitan Classic",
            imageName: "cosmopolitan-classic",
            ingredients: ["Vodka": 23, "Triple Sec": 15, "Cranberry Juice": 30, "Lime Juice": 15]))
        
        items.append(createDrinkWithIngredient("Margarita",
            imageName: "margarita",
            ingredients: ["Tequila": 30, "Triple Sec": 30, "Lime Juice": 15]))
        
        items.append(createDrinkWithIngredient("Vodka Cranberry",
            imageName: "vodka-cranberry",
            ingredients: ["Vodka": 30, "Cranberry Juice": 135, "Lime Juice": 15, "Orange Juice": 45]))
        
        items.append(createDrinkWithIngredient("Black Widow",
            imageName: "black-widow",
            ingredients: ["Vodka": 30, "Cranberry Juice": 30, "Lemonade": 30]))
        
        items.append(createDrinkWithIngredient("Rum and Coke",
            imageName: "rum-and-coke",
            ingredients: ["Light Rum": 30, "Coca Cola": 150]))
        
        items.append(createDrinkWithIngredient("Mix Your Own!!",
            imageName: "mix-your-own",
            ingredients: ["Light Rum": 0, "Vodka": 0, "Gin": 0, "Tequila": 0, "Triple Sec": 0, "Coca Cola": 0, "Lemonade": 0, "Orange Juice": 0, "Cranberry Juice": 0]))
        
        items.append(createDrinkWithIngredient("Hula-Hula",
            imageName: "hula-hula",
            ingredients: ["Gin": 60, "Orange Juice": 30, "Triple Sec": 5 ]))
        
        items.append(createDrinkWithIngredient("Kamikaze",
            imageName: "kamikaze",
            ingredients: ["Vodka": 15, "Triple Sec": 8]))
        
        items.append(createDrinkWithIngredient("Gimlet",
            imageName: "gimlet",
            ingredients: ["Gin": 90, "Lime Juice": 30]))
        
        items.append(createDrinkWithIngredient("Screwdriver",
            imageName: "screwdriver",
            ingredients: ["Vodka": 45, "Orange Juice": 120]))
        
        
        items.append(createDrinkWithIngredient("Vodka Lemonade",
            imageName: "vodka-lemonade",
            ingredients: ["Vodka": 30, "Lemonade": 150]))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        carousel.currentItemIndex = selectedDrinkIndex
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        items = Drink.allDrinks(managedContext!)
        if(items.count == 0){
            initDatabase()
        }
        
        carousel.frame = view.frame
        carousel.type = .Custom
        carousel.dataSource = self
        carousel.delegate = self
        carousel.centerItemWhenSelected = false
        view.addSubview(carousel)
        
        pageControl.numberOfPages = items.count
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
        return (carousel.itemViewAtIndex(selectedDrinkIndex)! as! DrinkView).imageView
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return items.count
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel!){
        pageControl.currentPage = carousel.currentItemIndex
    }
    
    func carousel(_carousel: iCarousel!, didSelectItemAtIndex index: Int) {
        var drinkDetailsVC = DrinkDetailsViewController(drink: self.items[index])
        
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
        if (view == nil) {
            var newView = DrinkView(frame: Constants.drinkFrames.basicFrame)
            newView.setDrink(items[index])
            return newView
        } else {
            (view as! DrinkView).setDrink(items[index])
            return view
        }
    }
}
