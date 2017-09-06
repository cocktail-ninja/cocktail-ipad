//
//  AdminViewController.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 21/10/15.
//  Copyright © 2015 tw. All rights reserved.
//

import Foundation
import UIKit

class AdminViewController: UIViewController {
    
    var coreDataStack: CoreDataStack!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func mappingCLicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "IngredientMappingViewController") as! IngredientMappingViewController
        controller.coreDataStack = coreDataStack

        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func cleaningClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CleaningViewController") as! CleaningViewController
        controller.coreDataStack = coreDataStack
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func logoutClicked() {
        AdminService.sharedInstance.logout()
        navigationController?.popViewController(animated: true)
    }
    
}
