//
//  DrinkDetailsViewController.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 1/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit
import iOSSharedViewTransition


class DrinkDetailsViewController: UIViewController, ASFSharedViewTransitionDataSource, UITableViewDataSource, UITableViewDelegate {
    let drinkImageView = UIImageView(frame: Constants.drinkFrames.expandedFrame),
        backButton = UIButton.buttonWithType(UIButtonType.System) as UIButton,
        pourButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton,
        resetIngredientButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton,
        pouringView = PouringView(frame: Constants.drinkFrames.expandedFrame),
        plzHide = UIView(),
        ingredientsTableView = UITableView();
    
    var drink: Drink?
    
    
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
        view.addSubview(resetIngredientButton)
        
        
        ingredientsTableView.frame = CGRectMake(400, 180, 550, 450)
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.scrollEnabled = false
        ingredientsTableView.separatorStyle = .None
        ingredientsTableView.allowsSelection = false
        plzHide.addSubview(ingredientsTableView)
        
        
        var label = UILabel(frame: CGRectMake(500, 100, 500, 50))
        label.text = drink.name
        label.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        label.textAlignment = .Center
        plzHide.addSubview(label)
        
        pouringView.setImage(drinkImageView.image!)
        pouringView.alpha = 0
        
        
        resetIngredientButton.addTarget(self, action: "reset", forControlEvents: .TouchUpInside)
        backButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        pourButton.addTarget(self, action: "pour", forControlEvents: .TouchUpInside)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drink!.drinkIngredients.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? DrinkIngredientCell
        if(cell == nil)
        {
            cell = DrinkIngredientCell(style: .Default, reuseIdentifier: "CELL")
        }
        
        var drinkIngredient = drink?.drinkIngredients.allObjects[indexPath.row] as DrinkIngredient
        
        cell!.displayDrinkIngredient(drinkIngredient)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70;
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
    
    func reset(){
        drink = Drink.getDrinkByName(drink!.name)
        ingredientsTableView.reloadData()
    }
    
    func dismiss(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    func pour(){
        DrinkService.makeDrink(recipe: "4-120/1-30")
            .then { (duration)  in
                self.startPourAnimation(duration)                
            }
    }
    
    func startPourAnimation(duration: Double){
        var pouringVC = PouringViewController(drink: drink!, duration: duration)
        navigationController?.pushViewController(pouringVC, animated: true)
    }
    
    func sharedView() -> UIView! {
        return drinkImageView
    }
}