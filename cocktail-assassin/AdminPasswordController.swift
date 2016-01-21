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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelClicked")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneClicked")
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func cancelClicked() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func doneClicked() {
        if AdminService.sharedInstance.login(passwordField.text!) {
            let navController = self.navigationController!
            let controllers = NSMutableArray(array: navController.viewControllers)
            controllers.replaceObjectAtIndex(controllers.count-1, withObject: adminMenuController())
            navController.setViewControllers(controllers as NSArray as! [UIViewController], animated: true)
        } else {
            showIncorrectPasswordAlert()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        doneClicked()
        return true
    }
    
    private func adminMenuController() -> AdminViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("AdminViewController") as! AdminViewController
        controller.coreDataStack = coreDataStack
        return controller
    }
    
    func showIncorrectPasswordAlert() {
        let controller = UIAlertController(title: "Incorrect Password", message: "Please try again", preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(controller, animated: true, completion: nil)
    }
            
}
