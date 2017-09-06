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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Select Ingredient For \(component.name)"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return super.numberOfSections(in: tableView) + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsForSection(section)?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        }

        if let ingredient = ingredientForIndexPath(indexPath) {
            cell!.textLabel?.text = ingredient.ingredientType.rawValue
            let component = Component.componentMappedToIngredient(ingredient, context: coreDataStack.context)
            cell!.textLabel?.textColor = component != nil ? UIColor.gray : UIColor.black
        } else {
            cell?.textLabel?.text = "None"
            cell!.textLabel?.textColor = UIColor.black
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let ingredient = ingredientForIndexPath(indexPath) else {
            delegate?.didSelectIngredient(nil)
            return
        }
        if let component = Component.componentMappedToIngredient(ingredient, context: coreDataStack.context) {
            let alertController = UIAlertController(title: "", message: "\(ingredient.name) already mapped to \(component.name)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        delegate?.didSelectIngredient(ingredient)
    }
    
}
