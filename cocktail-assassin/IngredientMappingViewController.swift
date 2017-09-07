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

class IngredientMappingViewController: UICollectionViewController {
    
    let MARGIN = 20
    var coreDataStack: CoreDataStack!
    var sections: [[Component]]!
    var selectedComponent: Component?
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        super.init(nibName: "IngredientMappingView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sections = [
            Component.componentsOfType(.valve, managedContext: coreDataStack.context),
            Component.componentsOfType(.pump, managedContext: coreDataStack.context)
        ]
        
        self.navigationItem.title = "Ingredient Mapping"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(IngredientMappingViewController.cancelClicked)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(IngredientMappingViewController.doneClicked)
        )
        
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
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Collection View Methods
    
    enum CleaningSection: Int {
        case valves = 0
        case pumps = 1
    }
    
    func componentForIndexPath(_ indexPath: IndexPath) -> Component {
        return sections[indexPath.section][indexPath.row]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ComponentCell",
            for: indexPath
        ) as! ComponentMappingCell
        cell.delegate = self
        let component = componentForIndexPath(indexPath)
        cell.update(component)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let count = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        let width = (view.frame.size.width - CGFloat((count-1) * MARGIN) - 40) / CGFloat(count)
        return CGSize(width: width, height: 100)
    }

}

extension IngredientMappingViewController: SelectIngredientDelegate {
    
    func didSelectIngredient(_ ingredient: Ingredient?) {
        selectedComponent?.ingredient = ingredient
        self.navigationController?.popViewController(animated: true)
        self.collectionView?.reloadData()
    }
    
    func didCancel() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension IngredientMappingViewController: ComponentCollectionCellDelegate {

    func componentSelected(_ component: Component) {
        selectedComponent = component
        
        let selectIngredientController = SelectIngrediantForComponentViewController(component: selectedComponent!, coreDataStack: coreDataStack)
        selectIngredientController.delegate = self
        selectIngredientController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        selectIngredientController.hidesBottomBarWhenPushed = false
        
        self.navigationController?.pushViewController(selectIngredientController, animated: true)
    }
}
