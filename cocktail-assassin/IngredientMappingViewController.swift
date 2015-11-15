//
//  IngredientMappingViewController.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 27/10/15.
//  Copyright © 2015 tw. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class IngredientMappingViewController: UITableViewController, SelectIngredientDelegate {
    
    var coreDataStack: CoreDataStack
    let sections: [[Component]]
    var selectedComponent: Component?
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.sections = [
            Component.componentsOfType(.Pump, managedContext: coreDataStack.context),
            Component.componentsOfType(.Valve, managedContext: coreDataStack.context)
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
    }
    
    func cancelClicked() {
        coreDataStack.reset()
        dismiss()
    }
    
    func doneClicked() {
        coreDataStack.save()
        dismiss()
    }
    
    func dismiss() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func didSelectIngredient(ingredient: Ingredient?) {
        selectedComponent?.ingredient = ingredient
        self.navigationController?.popViewControllerAnimated(true)
        self.tableView.reloadData()
    }
    
    func didCancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "CELL")
        }
        
        let component = sections[indexPath.section][indexPath.row]
        cell!.textLabel?.text = component.name
        cell!.detailTextLabel?.text = component.ingredient?.ingredientType.rawValue ?? ""
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Pump" : "Valve"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedComponent = sections[indexPath.section][indexPath.row]
        
        let selectIngredientController = SelectIngrediantForComponentViewController(component: selectedComponent!, coreDataStack: coreDataStack)
        selectIngredientController.delegate = self
        selectIngredientController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        selectIngredientController.hidesBottomBarWhenPushed = false
        
        self.navigationController?.pushViewController(selectIngredientController, animated: true)
    }
    
}
