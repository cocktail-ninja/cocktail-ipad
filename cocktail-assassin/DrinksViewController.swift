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

class DrinksViewController: UIViewController, iCarouselDataSource, iCarouselDelegate, ViewControllerDismissDelegate {
    private var carousel = iCarousel()
    private var pageControl = UIPageControl()
    private var transitionDrinkView = UIImageView()

    lazy var managedContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()
    
    
    var items:[Drink] = []

    func initIngredients(){
        Ingredient.newIngredient("Rum", pumpNumber: 1, amountLeft: 100, managedContext: managedContext!)
        Ingredient.newIngredient("Vodka", pumpNumber: 2, amountLeft: 100, managedContext: managedContext!)
        Ingredient.newIngredient("Gin", pumpNumber: 3, amountLeft: 100, managedContext: managedContext!)
        Ingredient.newIngredient("Lime", pumpNumber: 4, amountLeft: 50, managedContext: managedContext!)
      
        Ingredient.newIngredient("Coke", pumpNumber: 5, amountLeft: 400, managedContext: managedContext!)
        Ingredient.newIngredient("Cranberry", pumpNumber: 6, amountLeft: 500, managedContext: managedContext!)
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
        items.append(createDrinkWithIngredient("Rum and Coke", imageName: "cocktail-1", ingredients:["Rum":30, "Coke":50]))
        items.append(createDrinkWithIngredient("Vodka and Lime", imageName:"cocktail-2", ingredients:["Vodka":30, "Lime":50]))
        items.append(createDrinkWithIngredient("Gin and Cranberry", imageName:"cocktail-3", ingredients:["Gin":30, "Cranberry":50]))
        items.append(createDrinkWithIngredient("Metropolitan", imageName:"cocktail-4", ingredients:["Vodka":30, "Lime":50, "Cranberry":45]))
        items.append(createDrinkWithIngredient("Mixin", imageName:"cocktail-5", ingredients:["Rum":30, "Gin":50, "Vodka":20, "Lime":10, "Cranberry":45]))
        
        print(items);
        
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
        
        transitionDrinkView.contentMode = .ScaleAspectFit
        transitionDrinkView.hidden = true
        view.addSubview(transitionDrinkView)
    }
    
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return items.count
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel!){
        pageControl.currentPage = carousel.currentItemIndex
    }
    
    func onViewControllerDismiss(badpattern: Int){
        if (badpattern == 1){
            UIView.transitionWithView(self.transitionDrinkView,
                duration: 0.2,
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: {
                    self.transitionDrinkView.frame = Constants.drinkFrames.basicFrame
                }, completion: { finished in
                    self.carousel.reloadData()
                    
                    UIView.transitionWithView(self.view,
                        duration: 0.2,
                        options: UIViewAnimationOptions.CurveEaseIn,
                        animations: {
                            self.carousel.alpha = 1
                        }, completion:  { finished in
                            self.transitionDrinkView.hidden = true
                            
                    })
                    
            })
        } else if (badpattern == 2){
            self.carousel.reloadData()

            UIView.transitionWithView(self.view,
                duration: 0.2,
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: {
                    self.carousel.alpha = 1
                }, completion:  { finished in
                    self.transitionDrinkView.hidden = true
            })
        } else {
            self.transitionDrinkView.frame = Constants.drinkFrames.basicFrame
        }
    }
    
    func carousel(_carousel: iCarousel!, didSelectItemAtIndex index: Int) {
        var offset = _carousel.offsetForItemAtIndex(index)
        transitionDrinkView.frame = Constants.drinkFrames.basicFrame
        transitionDrinkView.scaleFrame(DrinkCarouselTransformation.getScale(offset))
        transitionDrinkView.setOriginX((view.frame.width/2) + DrinkCarouselTransformation.getXOffset(offset, carouselItemWidth: _carousel.itemWidth) - transitionDrinkView.frame.width/2)
        transitionDrinkView.setOriginY((view.frame.height - transitionDrinkView.frame.height)/2)
        
        transitionDrinkView.image = UIImage(named: items[index].imageName)
        
        transitionDrinkView.hidden = false
        (carousel.itemViewAtIndex(index) as UIImageView).image = nil
        
        var drinkDetailsVC = DrinkDetailsViewController(drink: self.items[index])
        drinkDetailsVC.dismissDelegate = self
        drinkDetailsVC.dismissDelegate = self
        
        UIView.transitionWithView(self.view,
            duration: 0.2,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.carousel.alpha = 0
            }, completion: { finished in
                UIView.transitionWithView(self.transitionDrinkView,
                    duration: 0.2,
                    options: UIViewAnimationOptions.CurveEaseOut,
                    animations: {
                        self.transitionDrinkView.frame = Constants.drinkFrames.expandedFrame
                    }, completion: { finished in
                        self.carousel.currentItemIndex = index
                        self.presentViewController(drinkDetailsVC, animated: false, completion: {
                            println("finished presenting")
                                                    })
                })
        })
        
        
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
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView! {
        if (view == nil) {
            view = DrinkView(frame: Constants.drinkFrames.basicFrame)
        }
        
        (view as DrinkView).setDrink(items[index])
        return view
    }
}
