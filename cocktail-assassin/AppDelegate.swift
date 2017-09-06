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
import PromiseKit


@objc @UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coreDataStack: CoreDataStack!
    var navigationController: UINavigationController!
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        coreDataStack = CoreDataStack() {
            print("Core Data Stack Initialized!")
            
            if WCSession.isSupported() {
                print("Starting WatchConnectivity session")
                self.session = WCSession.default()
            }
            
            self.displayMainUserInterface()
        }
        navigationController = self.window!.rootViewController as! UINavigationController
        
        ASFSharedViewTransition.addWith(
            fromViewControllerClass: DrinksViewController.self,
            toViewControllerClass: DrinkDetailsViewController.self,
            with: navigationController,
            withDuration: 0.5
        )
        
        ASFSharedViewTransition.addWith(
            fromViewControllerClass: DrinkDetailsViewController.self,
            toViewControllerClass: PouringViewController.self,
            with: navigationController,
            withDuration: 0.8
        )

        ASFSharedViewTransition.addWith(
            fromViewControllerClass: PouringViewController.self,
            toViewControllerClass: DrinksViewController.self,
            with: navigationController,
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
    
    func supportedInterfaceOrientationsForWindow(_ window: UIWindow) -> Int {
        return Int(UIInterfaceOrientationMask.all.rawValue)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        puts("message received: \(message)")
        
        let requestType = message["request"] as! String
        var response = [String: Any]()
        
        switch requestType {
        case "drinks":
            response = self.handleLoadDrinksRequest()
        case "pourDrink":
            response = self.handlePourDrinkRequest(message as [String : AnyObject])
        default:
            response = ["status": "unknown request" as AnyObject]
        }
        
        puts("sending response: \(message)")
        replyHandler(response)
    }
    
    func handleLoadDrinksRequest() -> [String: Any] {
        let drinks = Drink.allDrinks(coreDataStack.context)
        let drinkData = drinks.map() { drink in
            return [
                "title": drink.name,
                "image": drink.origImageName
            ]
        }
        return ["drinks": drinkData]
    }
    
    func handlePourDrinkRequest(_ message: [String : AnyObject]) -> [String: AnyObject] {
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
        let recipe = ingredientComponents.joined(separator: "/")
        
        firstly {
            DrinkService.makeDrink(recipe: recipe)
        }.then { duration -> Void in
            self.perform(#selector(self.sendPourDuration), with: nil, afterDelay: duration)
        }.catch { error in
            print("Error occurred while pouring drink from watch request")
        }
        return ["status": "success" as AnyObject]
    }
    
    func sendPourDuration() {
        session!.sendMessage(["event": "drinkPoured"], replyHandler: nil, errorHandler: nil)
    }
    
}

extension AppDelegate: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith")
    }
    
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
}

