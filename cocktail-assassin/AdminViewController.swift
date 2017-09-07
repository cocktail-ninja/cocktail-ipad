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
    
    lazy var mainStoryboard: UIStoryboard = {
        return UIStoryboard(name: "Main", bundle: nil)
    }()
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        super.init(nibName: "AdminView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction
    func mappingClicked() {
        let controller = IngredientMappingViewController.initialise(coreDataStack: coreDataStack)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction
    func cleaningClicked() {
        let controller = CleaningViewController.initialise(coreDataStack: coreDataStack)
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction
    func logoutClicked() {
        AdminService.sharedInstance.logout()
        navigationController?.popViewController(animated: true)
    }
    
}
