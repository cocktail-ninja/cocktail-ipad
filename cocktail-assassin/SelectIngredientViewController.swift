//
// Created by Colin Harris on 6/5/15.
// Copyright (c) 2015 tw. All rights reserved.
//

import UIKit

protocol SelectIngredientDelegate {
    func didSelectIngredient(ingredient: Ingredient)
    func didCancel()
}

class SelectIngredientViewController : UITableViewController {

    var ingredients: Array<Ingredient>
    var delegate: SelectIngredientDelegate?

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(ingredients: [Ingredient]) {
        self.ingredients = ingredients
        
        super.init(nibName: nil, bundle: nil)
        
//        self.preferredContentSize = CGSizeMake(250,439)
//        self.tableView.scrollEnabled = false
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
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        if(cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "CELL")
        }

        let ingredient = ingredients[indexPath.row]

        cell!.textLabel?.text = ingredient.ingredientType.rawValue

        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectIngredient(ingredients[indexPath.row])
    }
    
}
