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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Select Ingredient For Drink"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let ingredient = ingredientForIndexPath(indexPath)!
        cell.textLabel?.textColor = drink.containsIngredient(ingredient) ? UIColor.gray : UIColor.black
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = ingredientForIndexPath(indexPath)!
        if drink.containsIngredient(ingredient) {
            let alertController = UIAlertController(title: "", message: "Drink already has \(ingredient.ingredientType.rawValue)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        delegate?.didSelectIngredient(ingredient)
    }
    
}
