//
//  DrinkService.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 10/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import CoreData

class DrinkService: NSObject {
    
    class func maximumDrinkAmount() -> Int {
        return 260
    }
    
    // Recipe = "P1-30/P2-15/V3-150"
    class func makeDrink(recipe: String) -> Promise<Double> {
        let url = Constants.BaseUrl.prod + "/make_drink/" + recipe
        
        return Promise<Double> { fulfill, reject in
            Alamofire.request(url, method: .post)
                .responseJSON { (response) in
                    switch response.result {
                        case .success(let value):
                            let statusCode = response.response?.statusCode ?? 500
                            if statusCode == 200 {
                                let stringValue = (value as! NSDictionary)["ready_in"] as! NSString
                                let readyIn = stringValue.doubleValue / 1000
                                fulfill(readyIn)
                            } else {
                                let statusError = NSError(domain: "DrinkService", code: statusCode, userInfo: nil)
                                reject(statusError)
                            }
                        case .failure(let error):
                            reject(error)
                    }
            }
        }
    }
    
    class func initIngredients(_ managedContext: NSManagedObjectContext) {
        Ingredient.newIngredient(.darkRum, pumpNumber: 1, amountLeft: 100, ingredientClass: .alcoholic, managedContext: managedContext)
        Ingredient.newIngredient(.lightRum, pumpNumber: 2, amountLeft: 100, ingredientClass: .alcoholic, managedContext: managedContext)
        Ingredient.newIngredient(.vodka, pumpNumber: 3, amountLeft: 100, ingredientClass: .alcoholic, managedContext: managedContext)
        Ingredient.newIngredient(.gin, pumpNumber: 4, amountLeft: 100, ingredientClass: .alcoholic, managedContext: managedContext)
        Ingredient.newIngredient(.tequila, pumpNumber: 5, amountLeft: 50, ingredientClass: .alcoholic, managedContext: managedContext)
        Ingredient.newIngredient(.tripleSec, pumpNumber: 6, amountLeft: 50, ingredientClass: .alcoholic, managedContext: managedContext)
      
        Ingredient.newIngredient(.coke, pumpNumber: 7, amountLeft: 400, ingredientClass: .nonAlcoholic, managedContext: managedContext)
        Ingredient.newIngredient(.lemonade, pumpNumber: 8, amountLeft: 500, ingredientClass: .nonAlcoholic, managedContext: managedContext)
        Ingredient.newIngredient(.orangeJuice, pumpNumber: 9, amountLeft: 400, ingredientClass: .nonAlcoholic, managedContext: managedContext)
        Ingredient.newIngredient(.cranberryJuice, pumpNumber: 10, amountLeft: 500, ingredientClass: .nonAlcoholic, managedContext: managedContext)
        Ingredient.newIngredient(.limeJuice, pumpNumber: 11, amountLeft: 500, ingredientClass: .nonAlcoholic, managedContext: managedContext)
    }
    
    class func initComponents(_ managedContext: NSManagedObjectContext) {
        Component.newComponent(.valve, id: "V1", name: "Valve 1", managedContext: managedContext)
        Component.newComponent(.valve, id: "V2", name: "Valve 2", managedContext: managedContext)
        Component.newComponent(.valve, id: "V3", name: "Valve 3", managedContext: managedContext)
        Component.newComponent(.valve, id: "V4", name: "Valve 4", managedContext: managedContext)
        
        Component.newComponent(.pump, id: "P1", name: "Pump 1", managedContext: managedContext)
        Component.newComponent(.pump, id: "P2", name: "Pump 2", managedContext: managedContext)
        Component.newComponent(.pump, id: "P3", name: "Pump 3", managedContext: managedContext)
        Component.newComponent(.pump, id: "P4", name: "Pump 4", managedContext: managedContext)
        Component.newComponent(.pump, id: "P5", name: "Pump 5", managedContext: managedContext)
        Component.newComponent(.pump, id: "P6", name: "Pump 6", managedContext: managedContext)
    }
    
    @discardableResult
    class func createDrinkWithIngredient(_ name: String,
                                         imageName: String,
                                         ingredients: [IngredientType: NSNumber],
                                         editable: Bool,
                                         coreDataStack: CoreDataStack) -> Drink {
        let drink = Drink.newDrink(name, imageName: imageName, editable: editable, managedContext: coreDataStack.context)
        
        for (ingredientType, amountNeeded) in ingredients {
            drink.addIngredient(Ingredient.getIngredient(ingredientType, managedContext: coreDataStack.context)!, amount: amountNeeded)
        }
        
        coreDataStack.save()
        return drink
    }
    
    class func initDatabase(_ coreDataStack: CoreDataStack) {
        DrinkService.initComponents(coreDataStack.context)
        DrinkService.initIngredients(coreDataStack.context)

        DrinkService.createDrinkWithIngredient("Long Island Iced Tea",
            imageName: "long-island-iced-tea",
            ingredients: [.vodka: 15, .lightRum: 15, .tequila: 15, .tripleSec: 15, .gin: 15, .coke: 90],
            editable: false,
            coreDataStack: coreDataStack)
        
        DrinkService.createDrinkWithIngredient("Alpine Lemonade",
            imageName: "alpine-lemonade",
            ingredients: [.vodka: 30, .gin: 30, .lightRum: 30, .lemonade: 60, .cranberryJuice: 60],
            editable: false,
            coreDataStack: coreDataStack)
        
        DrinkService.createDrinkWithIngredient("The Ollie",
            imageName: "the-ollie",
            ingredients: [.vodka: 60, .lightRum: 30, .tequila: 30, .lemonade: 150],
            editable: false,
            coreDataStack: coreDataStack)
        
        DrinkService.createDrinkWithIngredient("Cosmopolitan Classic",
            imageName: "cosmopolitan",
            ingredients: [.vodka: 15, .tripleSec: 15, .cranberryJuice: 30, .limeJuice: 15],
            editable: false,
            coreDataStack: coreDataStack)
        
        DrinkService.createDrinkWithIngredient("Margarita",
            imageName: "margarita",
            ingredients: [.tequila: 30, .tripleSec: 30, .limeJuice: 15],
            editable: false,
            coreDataStack: coreDataStack)
        
        DrinkService.createDrinkWithIngredient("Vodka Cranberry",
            imageName: "vodka-cranberry",
            ingredients: [.vodka: 30, .cranberryJuice: 120, .limeJuice: 15, .orangeJuice: 30],
            editable: false,
            coreDataStack: coreDataStack)
        
        DrinkService.createDrinkWithIngredient("Black Widow",
            imageName: "black-widow",
            ingredients: [.vodka: 30, .cranberryJuice: 30, .lemonade: 30],
            editable: false,
            coreDataStack: coreDataStack)
        
        DrinkService.createDrinkWithIngredient("Rum and Coke",
            imageName: "rum-and-coke",
            ingredients: [.lightRum: 30, .coke: 150],
            editable: false,
            coreDataStack: coreDataStack)
        
        DrinkService.createDrinkWithIngredient("Mix Your Own!!",
            imageName: "mix-your-own",
            ingredients: [.lightRum: 0, .vodka: 0, .gin: 0, .tequila: 0, .tripleSec: 0, .coke: 0, .lemonade: 0, .orangeJuice: 0, .cranberryJuice: 0],
            editable: false,
            coreDataStack: coreDataStack)
        
        DrinkService.createDrinkWithIngredient("Hula-Hula",
            imageName: "hula-hula",
            ingredients: [.gin: 60, .orangeJuice: 30, .tripleSec: 7.5 ],
            editable: false,
            coreDataStack: coreDataStack)
        
        DrinkService.createDrinkWithIngredient("Kamikaze",
            imageName: "kamikaze",
            ingredients: [.vodka: 15, .tripleSec: 7.5],
            editable: false,
            coreDataStack: coreDataStack)
    }
}
