//
// Created by Colin Harris on 6/5/15.
// Copyright (c) 2015 tw. All rights reserved.
//

import UIKit

protocol SelectIngredientDelegate {
    func didSelectIngredient(ingredient: Ingredient?)
    func didCancel()
}

class SelectIngredientViewController : UITableViewController {

    var ingredients: [Ingredient]
    var coreDataStack: CoreDataStack
    var delegate: SelectIngredientDelegate?
    
    var alcoholicSection: Int = 0
    var nonAlcoholicSection: Int = 1
    
    // Options
    var hideUnavailableIngredients: Bool = true

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(ingredients: [Ingredient], coreDataStack: CoreDataStack) {
        self.ingredients = ingredients
        self.coreDataStack = coreDataStack
        
        super.init(nibName: nil, bundle: nil)
    }

    var alcoholicIngredients: [Ingredient] {
        var results = ingredients.filter() { $0.isAlcoholic() }
        if hideUnavailableIngredients {
            results = results.filter() { $0.component != nil }
        }
        return results
    }
    
    var nonAlcoholicIngredients: [Ingredient] {
        var results = ingredients.filter() { !$0.isAlcoholic() }
        if hideUnavailableIngredients {
            results = results.filter() { $0.component != nil }
        }
        return results
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Select Ingredient"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelClicked")
    }
    
    func cancelClicked() {
        delegate?.didCancel()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsForSection(section)?.count ?? 0
    }
    
    func ingredientForIndexPath(indexPath: NSIndexPath) -> Ingredient? {
        return ingredientsForSection(indexPath.section)?[indexPath.row]
    }
    
    func ingredientsForSection(section: Int) -> [Ingredient]? {
        switch(section) {
        case(alcoholicSection):
            return alcoholicIngredients
        case(nonAlcoholicSection):
            return nonAlcoholicIngredients
        default:
            return nil
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "CELL")
        }
        let ingredient = ingredientForIndexPath(indexPath)
        cell!.textLabel?.text = ingredient?.ingredientType.rawValue
        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let ingredient = ingredientForIndexPath(indexPath) {
            delegate?.didSelectIngredient(ingredient)
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case(alcoholicSection):
            return "Alcoholic"
        case(nonAlcoholicSection):
            return "Non-Alcoholic"
        default:
            return ""
        }
    }
    
}
