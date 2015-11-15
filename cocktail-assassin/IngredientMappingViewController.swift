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

class IngredientMappingViewController: UICollectionViewController, SelectIngredientDelegate, ComponentCollectionCellDelegate {
    
    let MARGIN = 20
    var coreDataStack: CoreDataStack!
    var sections: [[Component]]!
    var selectedComponent: Component?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sections = [
            Component.componentsOfType(.Valve, managedContext: coreDataStack.context),
            Component.componentsOfType(.Pump, managedContext: coreDataStack.context)
        ]
        
        self.navigationItem.title = "Ingredient Mapping"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelClicked")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneClicked")
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
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
        self.collectionView?.reloadData()
    }
    
    func didCancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: Collection View Methods
    
    enum CleaningSection: Int {
        case Valves = 0
        case Pumps = 1
    }
    
    func componentForIndexPath(indexPath: NSIndexPath) -> Component {
        return sections[indexPath.section][indexPath.row]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ComponentCell", forIndexPath: indexPath) as! ComponentMappingCell
        cell.delegate = self
        let component = componentForIndexPath(indexPath)
        cell.update(component)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let count = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        let width = (view.frame.size.width - CGFloat((count-1) * MARGIN) - 40) / CGFloat(count)
        return CGSize(width: width, height: 100)
    }
    
    // MARK: ComponentCollectionCellDelegate
    
    func componentSelected(component: Component) {
        selectedComponent = component
        
        let selectIngredientController = SelectIngrediantForComponentViewController(component: selectedComponent!, coreDataStack: coreDataStack)
        selectIngredientController.delegate = self
        selectIngredientController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        selectIngredientController.hidesBottomBarWhenPushed = false
        
        self.navigationController?.pushViewController(selectIngredientController, animated: true)
    }
    
}
