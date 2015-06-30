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
    
    class func makeDrink(recipe recipe: String) -> Promise<Double?> {
        let url = Constants.baseUrl.prod + "/make_drink/" + recipe
        
        return Promise<Double?> { fulfill, reject in
            let innerFulfill = fulfill
            let innerReject = reject
            Alamofire.request(.POST, URLString: url)
                .responseJSON { (request, response, data, error) in
                    if let anError = error  {
                        innerReject(anError)
                    } else if response?.statusCode == 200 {
                        let stringValue = (data as! NSDictionary)["ready_in"] as! NSString
                        let readyIn = stringValue.doubleValue / 1000
                        NSLog("Ready In: \(readyIn)")
                        innerFulfill(readyIn)
                    } else {
                        let statusError = NSError(domain: "DrinkService", code: response!.statusCode, userInfo: nil)
                        innerReject(statusError)
                    }
            }
        }
        
    }
    class func initIngredients(managedContext: NSManagedObjectContext) {
        Ingredient.newIngredient("Light Rum", pumpNumber: 1, amountLeft: 100, ingredientClass: .Alcoholic, managedContext: managedContext)
        Ingredient.newIngredient("Vodka", pumpNumber: 2, amountLeft: 100, ingredientClass: .Alcoholic, managedContext: managedContext)
        Ingredient.newIngredient("Gin", pumpNumber: 3, amountLeft: 100, ingredientClass: .Alcoholic,managedContext: managedContext)
        Ingredient.newIngredient("Tequila", pumpNumber: 4, amountLeft: 50, ingredientClass: .Alcoholic, managedContext: managedContext)
        Ingredient.newIngredient("Triple Sec", pumpNumber: 5, amountLeft: 50, ingredientClass: .Alcoholic,managedContext: managedContext)
      
        Ingredient.newIngredient("Coca Cola", pumpNumber: 7, amountLeft: 400, ingredientClass: .NonAlcoholic, managedContext: managedContext)
        Ingredient.newIngredient("Lemonade", pumpNumber: 6, amountLeft: 500, ingredientClass: .NonAlcoholic, managedContext: managedContext)
        Ingredient.newIngredient("Orange Juice", pumpNumber: 8, amountLeft: 400, ingredientClass: .NonAlcoholic, managedContext: managedContext)
        Ingredient.newIngredient("Cranberry Juice", pumpNumber: 9, amountLeft: 500, ingredientClass: .NonAlcoholic, managedContext: managedContext)
        Ingredient.newIngredient("Lime Juice", pumpNumber: 10, amountLeft: 500, ingredientClass: .NonAlcoholic, managedContext: managedContext)
    }
    
    class func createDrinkWithIngredient(name:String, imageName:String, ingredients: Dictionary<String, NSNumber>, editable: Bool, managedContext: NSManagedObjectContext) -> Drink {
        let drink = Drink.newDrink(name, imageName: imageName, editable: editable, managedContext: managedContext)
        
        for (ingredientName, amountNeeded) in ingredients{
            drink.addIngredient(Ingredient.getIngredient(ingredientName, managedContext: managedContext)!, amount: amountNeeded)
        }
        
        Drink.save()
        return drink
    }
    
    class func initDatabase(managedContext: NSManagedObjectContext) {
        DrinkService.initIngredients(managedContext)

        DrinkService.createDrinkWithIngredient("Long Island Ice Tea",
            imageName: "long-island-iced-tea",
            ingredients: ["Vodka": 15, "Light Rum": 15, "Tequila": 15, "Triple Sec": 15, "Gin": 15, "Coca Cola": 90],
            editable: false,
            managedContext: managedContext)
        
        DrinkService.createDrinkWithIngredient("Alpine Lemonade",
            imageName: "alpine-lemonade",
            ingredients: ["Vodka": 30, "Gin": 30, "Light Rum": 30, "Lemonade": 60, "Cranberry Juice": 60],
            editable: false,
            managedContext: managedContext)
        
        DrinkService.createDrinkWithIngredient("The Ollie",
            imageName: "the-ollie",
            ingredients: ["Vodka": 60, "Light Rum": 30, "Tequila": 30, "Lemonade": 150],
            editable: false,
            managedContext: managedContext)
        
        DrinkService.createDrinkWithIngredient("Cosmopolitan Classic",
            imageName: "cosmopolitan",
            ingredients: ["Vodka": 15, "Triple Sec": 15, "Cranberry Juice": 30, "Lime Juice": 15],
            editable: false,
            managedContext: managedContext)
        
        DrinkService.createDrinkWithIngredient("Margarita",
            imageName: "margarita",
            ingredients: ["Tequila": 30, "Triple Sec": 30, "Lime Juice": 15],
            editable: false,
            managedContext: managedContext)
        
        DrinkService.createDrinkWithIngredient("Vodka Cranberry",
            imageName: "vodka-cranberry",
            ingredients: ["Vodka": 30, "Cranberry Juice": 120, "Lime Juice": 15, "Orange Juice": 30],
            editable: false,
            managedContext: managedContext)
        
        DrinkService.createDrinkWithIngredient("Black Widow",
            imageName: "black-widow",
            ingredients: ["Vodka": 30, "Cranberry Juice": 30, "Lemonade": 30],
            editable: false,
            managedContext: managedContext)
        
        DrinkService.createDrinkWithIngredient("Rum and Coke",
            imageName: "rum-and-coke",
            ingredients: ["Light Rum": 30, "Coca Cola": 150],
            editable: false,
            managedContext: managedContext)
        
        DrinkService.createDrinkWithIngredient("Mix Your Own!!",
            imageName: "mix-your-own",
            ingredients: ["Light Rum": 0, "Vodka": 0, "Gin": 0, "Tequila": 0, "Triple Sec": 0, "Coca Cola": 0, "Lemonade": 0, "Orange Juice": 0, "Cranberry Juice": 0],
            editable: false,
            managedContext: managedContext)
        
        DrinkService.createDrinkWithIngredient("Hula-Hula",
            imageName: "hula-hula",
            ingredients: ["Gin": 60, "Orange Juice": 30, "Triple Sec": 7.5 ],
            editable: false,
            managedContext: managedContext)
        
        DrinkService.createDrinkWithIngredient("Kamikaze",
            imageName: "kamikaze",
            ingredients: ["Vodka": 15, "Triple Sec": 7.5],
            editable: false,
            managedContext: managedContext)
    }
}
