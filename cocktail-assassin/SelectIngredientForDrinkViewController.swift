//
//  SelectIngredientForDrinkViewController.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 16/11/15.
//  Copyright © 2015 tw. All rights reserved.
//

import UIKit

class SelectIngredientForDrinkViewController: SelectIngredientViewController {
    
    var drink: Drink
    
    init(drink: Drink, coreDataStack: CoreDataStack) {
        self.drink = drink
        let ingredients = Ingredient.allIngredients(coreDataStack.context)
        super.init(ingredients: ingredients, coreDataStack: coreDataStack)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Select Ingredient For Drink"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        let ingredient = ingredientForIndexPath(indexPath)!
        cell.textLabel?.textColor = drink.containsIngredient(ingredient) ? UIColor.grayColor() : UIColor.blackColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ingredient = ingredientForIndexPath(indexPath)!
        if drink.containsIngredient(ingredient) {
            let alertController = UIAlertController(title: "", message: "Drink already has \(ingredient.ingredientType.rawValue)", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        delegate?.didSelectIngredient(ingredient)
    }
    
}
