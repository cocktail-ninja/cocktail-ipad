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

class AdminPasswordController: UIViewController {
    
    let coreDataStack: CoreDataStack
    
    @IBOutlet var passwordField: UITextField!
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        super.init(nibName: "AdminPasswordView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Admin Password"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(AdminPasswordController.cancelClicked)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(AdminPasswordController.doneClicked)
        )
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func cancelClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneClicked() {
        if AdminService.sharedInstance.login(passwordField.text!) {
            let navController = self.navigationController!
            var controllers = Array(navController.viewControllers)
            controllers[controllers.count-1] = adminMenuController()
            navController.setViewControllers(controllers, animated: true)
        } else {
            showIncorrectPasswordAlert()
        }
    }
    
    fileprivate func adminMenuController() -> AdminViewController {
        return AdminViewController(coreDataStack: coreDataStack)
    }
    
    func showIncorrectPasswordAlert() {
        let controller = UIAlertController(title: "Incorrect Password", message: "Please try again", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
            
}

extension AdminPasswordController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneClicked()
        return true
    }
}
