//
//  SelectIngredientForComponentViewController.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 16/11/15.
//  Copyright © 2015 tw. All rights reserved.
//

import UIKit

class SelectIngrediantForComponentViewController: SelectIngredientViewController {
    
    var component: Component
    
    init(component: Component, coreDataStack: CoreDataStack) {
        self.component = component
        let ingredients = Ingredient.allIngredients(coreDataStack.context)
        super.init(ingredients: ingredients, coreDataStack: coreDataStack)
        self.alcoholicSection = 1
        self.nonAlcoholicSection = 2
        self.hideUnavailableIngredients = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Select Ingredient For \(component.name)"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return super.numberOfSectionsInTableView(tableView) + 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsForSection(section)?.count ?? 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "CELL")
        }

        if let ingredient = ingredientForIndexPath(indexPath) {
            cell!.textLabel?.text = ingredient.ingredientType.rawValue
            let component = Component.componentMappedToIngredient(ingredient, context: coreDataStack.context)
            cell!.textLabel?.textColor = component != nil ? UIColor.grayColor() : UIColor.blackColor()
        } else {
            cell?.textLabel?.text = "None"
            cell!.textLabel?.textColor = UIColor.blackColor()
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let ingredient = ingredientForIndexPath(indexPath) else {
            delegate?.didSelectIngredient(nil)
            return
        }
        if let component = Component.componentMappedToIngredient(ingredient, context: coreDataStack.context) {
            let alertController = UIAlertController(title: "", message: "\(ingredient.name) already mapped to \(component.name)", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        delegate?.didSelectIngredient(ingredient)
    }
    
}