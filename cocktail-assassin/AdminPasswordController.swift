//
//  AdminPasswordController.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 21/1/16.
//  Copyright © 2016 tw. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AdminPasswordController: UIViewController, UITextFieldDelegate {
    
    var coreDataStack: CoreDataStack!
    
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Admin Password"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(AdminPasswordController.cancelClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AdminPasswordController.doneClicked))
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func cancelClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneClicked() {
        if AdminService.sharedInstance.login(passwordField.text!) {
            let navController = self.navigationController!
            let controllers = NSMutableArray(array: navController.viewControllers)
            controllers.replaceObject(at: controllers.count-1, with: adminMenuController())
            navController.setViewControllers(controllers as NSArray as! [UIViewController], animated: true)
        } else {
            showIncorrectPasswordAlert()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneClicked()
        return true
    }
    
    fileprivate func adminMenuController() -> AdminViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AdminViewController") as! AdminViewController
        controller.coreDataStack = coreDataStack
        return controller
    }
    
    func showIncorrectPasswordAlert() {
        let controller = UIAlertController(title: "Incorrect Password", message: "Please try again", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
            
}
