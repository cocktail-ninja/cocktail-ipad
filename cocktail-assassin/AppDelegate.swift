//
//  AppDelegate.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 20/1/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit
import CoreData
import iOSSharedViewTransition

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var coreDataStack: CoreDataStack!
    var navigationController: UINavigationController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        coreDataStack = CoreDataStack() {
            print("Core Data Stack Initialized!")
            self.displayMainUserInterface()
        }
        navigationController = self.window!.rootViewController as! UINavigationController
        
        ASFSharedViewTransition.addTransitionWithFromViewControllerClass(
            DrinksViewController.self,
            toViewControllerClass: DrinkDetailsViewController.self,
            withNavigationController: navigationController,
            withDuration: 0.5
        )
        
        ASFSharedViewTransition.addTransitionWithFromViewControllerClass(
            DrinkDetailsViewController.self,
            toViewControllerClass: PouringViewController.self,
            withNavigationController: navigationController,
            withDuration: 0.8
        )

        ASFSharedViewTransition.addTransitionWithFromViewControllerClass(
            PouringViewController.self,
            toViewControllerClass: DrinksViewController.self,
            withNavigationController: navigationController,
            withDuration: 0.5
        )
            
        return true
    }

    func displayMainUserInterface() {
        let items = Drink.allDrinks(coreDataStack.context)
        if items.count == 0 {
            DrinkService.initDatabase(coreDataStack)
        }
        
        let loadingViewController = navigationController.topViewController as! LoadingViewControler
        loadingViewController.coreDataStack = coreDataStack
        loadingViewController.showDrinks()
    }
    
    func supportedInterfaceOrientationsForWindow(window: UIWindow) -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }
    
}

