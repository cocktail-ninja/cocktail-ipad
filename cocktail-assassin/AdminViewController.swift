//
//  AdminViewController.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 21/10/15.
//  Copyright © 2015 tw. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AdminViewController: UITableViewController, SelectIngredientDelegate {
    
    var managedObjectContext: NSManagedObjectContext
    var selectIngredientController: SelectIngredientViewController?
    let sections: [[Component]]
    var selectedComponent: Component?

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.sections = [
            Component.componentsOfType(.Valve, managedContext: managedObjectContext),
            Component.componentsOfType(.Pump, managedContext: managedObjectContext)
        ]
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Ingredient Mapping"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelClicked")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneClicked")
        
        view.backgroundColor = UIColor.whiteColor()
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        
        let ingredients = Ingredient.allIngredients(managedObjectContext)
        self.selectIngredientController = SelectIngredientViewController(ingredients: ingredients)
        selectIngredientController?.delegate = self
        selectIngredientController?.modalPresentationStyle = UIModalPresentationStyle.FormSheet
    }
    
    func cancelClicked() {
        managedObjectContext.reset()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doneClicked() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving component mapping!")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didSelectIngredient(ingredient: Ingredient) {
        selectedComponent?.ingredient = ingredient
        selectIngredientController!.dismissViewControllerAnimated(true) {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        
        if(cell == nil) {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "CELL")
        }
        
        let component = sections[indexPath.section][indexPath.row]
        cell!.textLabel?.text = component.name
        
        if let ingredient = component.ingredient {
            cell!.detailTextLabel?.text = ingredient.ingredientType.rawValue
        }
        
        return cell!
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedComponent = sections[indexPath.section][indexPath.row]
        self.presentViewController(selectIngredientController!, animated: true, completion: nil)
    }
    
}