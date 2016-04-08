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
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
                            
    var window: UIWindow?
    var coreDataStack: CoreDataStack!
    var navigationController: UINavigationController!
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        coreDataStack = CoreDataStack() {
            print("Core Data Stack Initialized!")
            
            if WCSession.isSupported() {
                print("Starting WatchConnectivity session")
                self.session = WCSession.defaultSession()
            }
            
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
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        puts("message received: \(message)")
        
        let requestType = message["request"] as! String
        var response = [String: AnyObject]()
        
        switch requestType {
        case "drinks":
            response = self.handleLoadDrinksRequest()
        case "pourDrink":
            response = self.handlePourDrinkRequest(message)
        default:
            response = ["status": "unknown request"]
        }
        
        puts("sending response: \(message)")
        replyHandler(response)
    }
    
    func handleLoadDrinksRequest() -> [String: AnyObject] {
        let drinks = Drink.allDrinks(coreDataStack.context)
        let drinkData = drinks.map() { drink in
            return [
                "title": drink.name,
                "image": drink.origImageName
            ]
        }
        return ["drinks": drinkData]
    }
    
    func handlePourDrinkRequest(message: [String : AnyObject]) -> [String: AnyObject] {
        let drinkName = message["drinkName"] as! String
        let drink = Drink.getDrinkByName(drinkName, context: coreDataStack.context)
        
        let ingredients = drink!.drinkIngredients.allObjects as! [DrinkIngredient]
        var ingredientComponents = ingredients.map {
            if let component = $0.ingredient.component {
                return "\(component.id)-\($0.amount)"
            } else {
                return ""
            }
        } as [String]
        ingredientComponents = ingredientComponents.filter() { value in
            return value != ""
        } as [String]
        let recipe = ingredientComponents.joinWithSeparator("/")
        
        DrinkService.makeDrink(recipe: recipe).then() { duration -> Void in
            self.performSelector("sendPourDuration", withObject: nil, afterDelay: duration)
        }.error() { error in
            print("Error occurred while pouring drink from watch request")
        }
        return ["status": "success"]
    }
    
    func sendPourDuration() {
        session!.sendMessage(["event": "drinkPoured"], replyHandler: nil, errorHandler: nil)
    }
    
}

