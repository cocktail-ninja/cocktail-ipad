//
// Created by Colin Harris on 6/5/15.
// Copyright (c) 2015 tw. All rights reserved.
//

import UIKit

protocol SelectIngredientDelegate {
    func didSelectIngredient(ingredient: Ingredient)
}

class SelectIngredientViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView
    var ingredients: Array<Ingredient>
    var delegate: SelectIngredientDelegate?

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(ingredients: [Ingredient]) {
        self.ingredients = ingredients
        // TODO: need to ad a navbar
        self.tableView = UITableView(frame: CGRectZero, style: .Plain)
        
        super.init(nibName: nil, bundle: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "|[tableView]|",
            options: [],
            metrics: nil,
            views: ["tableView":tableView]
        )
        view.addConstraints(constraint)
        constraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[tableView]|",
            options: [],
            metrics: nil,
            views: ["tableView":tableView]
        )
        view.addConstraints(constraint)
        
        self.preferredContentSize = CGSizeMake(250,439)
        self.tableView.scrollEnabled = false
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        if(cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "CELL")
        }

        let ingredient = ingredients[indexPath.row]

        cell!.textLabel?.text = ingredient.ingredientType.rawValue

        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectIngredient(ingredients[indexPath.row])
    }
    
}
