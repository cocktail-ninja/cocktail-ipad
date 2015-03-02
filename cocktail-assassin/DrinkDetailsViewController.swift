//
//  DrinkDetailsViewController.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 1/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit
import iOSSharedViewTransition


class DrinkDetailsViewController: UIViewController, ASFSharedViewTransitionDataSource {
    let drinkImageView = UIImageView(frame: Constants.drinkFrames.expandedFrame),
        backButton = UIButton.buttonWithType(UIButtonType.System) as UIButton,
        pourButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton,
        resetIngredientButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton,
        pouringView = PouringView(frame: Constants.drinkFrames.expandedFrame),
        plzHide = UIView(),
        drink: Drink?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(drink: Drink) {
        super.init()
        self.drink = drink
        plzHide.frame = view.frame
        
        
        drinkImageView.frame = Constants.drinkFrames.expandedFrame
        drinkImageView.contentMode = .ScaleAspectFit
        drinkImageView.image = UIImage(named: drink.imageName)
        
        backButton.setTitle("Back", forState: .Normal)
        backButton.setTitleColor(ThemeColor.primary, forState: UIControlState.Normal)
        backButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(20))
        backButton.frame = CGRectMake(30, 30, 100, 60)
        var backChevron = UILabel(frame: CGRectMake(-20, 0, 100, 60))
        backChevron.text = "〈"
        backChevron.font = UIFont.boldSystemFontOfSize(40)
        backChevron.textColor = ThemeColor.primary
        backButton.addSubview(backChevron)
        
        
        
        pourButton.setTitle("Insert cup and GO!", forState: .Normal)
        pourButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(32))
        pourButton.frame = CGRectMake(620, 650, 300, 60)
        pourButton.backgroundColor = UIColor.clearColor()
        pourButton.setTitleColor(ThemeColor.primary, forState: .Normal)
        pourButton.setBorder(1.0, color: ThemeColor.primary.CGColor, radius: 5.0)
        
        
        resetIngredientButton.setTitle("", forState: .Normal)
        resetIngredientButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(32))
        resetIngredientButton.frame = CGRectMake(620, 600, 300, 60)
        resetIngredientButton.backgroundColor = UIColor.clearColor()
        resetIngredientButton.setTitleColor(ThemeColor.primary, forState: .Normal)
        resetIngredientButton.setBorder(1.0, color: ThemeColor.primary.CGColor, radius: 5.0)
        
        
        
        
        
        var label = UILabel(frame: CGRectMake(500, 100, 500, 50))
        label.text = drink.name
        label.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        label.textAlignment = .Center
        plzHide.addSubview(label)
        
        
        print(drink.drinkIngredients)
        for ing in drink.drinkIngredients{
    
        }
        
        
        var ingredients = ["Vodka", "Rum", "Lemon Juice", "Cola"]
        
        var y : CGFloat = 0
        for ing in ingredients {
            var slider = UISlider(),
                ingredientNamelabel = UILabel(),
            ingredientAmountLabel = UILabel();
            
            
            slider.frame = CGRectMake(660, 220 + y, 250, 20)
            slider.setValue(0.5, animated: false)
            
            ingredientNamelabel.frame = CGRectMake(360, 220 + y, 200, 20)
            ingredientNamelabel.textAlignment = .Right
            ingredientNamelabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
            ingredientNamelabel.text = ing
            
            ingredientAmountLabel.frame = CGRectMake(440, 220 + y, 200, 20)
            ingredientAmountLabel.textAlignment = .Right
            ingredientAmountLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
            ingredientAmountLabel.text = "150ml"
   

            
            y += 70
            
            plzHide.addSubview(ingredientNamelabel)
            plzHide.addSubview(ingredientAmountLabel)
            plzHide.addSubview(slider)
        }
        
        pouringView.setImage(drinkImageView.image!)
        pouringView.alpha = 0
        
        backButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        pourButton.addTarget(self, action: "pour", forControlEvents: .TouchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(drinkImageView)
        plzHide.addSubview(pourButton)
        plzHide.addSubview(backButton)
        view.addSubview(pouringView)
        view.addSubview(plzHide)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("viewDidAppear")
    }
    
    func dismiss(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    func pour(){
        DrinkService.makeDrink(recipe: "4-120/1-30",
            onSuccess: { () -> Void in
                println("onSuccess")
                self.startPourAnimation(15)
            }, onFailure: { () -> Void in
                println("onFailure")
            })
    }
    
    func startPourAnimation(duration: Double){
        var pouringVC = PouringViewController(drink: drink!, duration: duration)
        navigationController?.pushViewController(pouringVC, animated: true)
    }
    
    func sharedView() -> UIView! {
        return drinkImageView
    }
}