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
    
    class func makeDrink(#recipe: String) -> Promise<Double> {
        var url = Constants.baseUrl.prod + "/make_drink/" + recipe
        
        return Promise<Double> { deferred in
            Alamofire.request(.POST, url)
                .responseJSON { (request, response, data, error) in
                    if let anError = error  {
                        deferred.reject(anError)                        
                    } else if response?.statusCode == 200 {
                        var readyIn = (data as! NSDictionary)["ready_in"] as! Double / 1000
                        NSLog("Ready In: \(readyIn)")
                        deferred.fulfill(readyIn)
                    } else {
                        var statusError = NSError(domain: "DrinkService", code: response!.statusCode, userInfo: nil)
                        deferred.reject(statusError)
                    }
            }
            return
        }
        
    }
    
    class func initIngredients(){
        Ingredient.newIngredient("Light Rum", pumpNumber: 1, amountLeft: 100, ingredientClass: .Alcoholic, managedContext: managedContext!)
        Ingredient.newIngredient("Vodka", pumpNumber: 2, amountLeft: 100, ingredientClass: .Alcoholic, managedContext: managedContext!)
        Ingredient.newIngredient("Gin", pumpNumber: 3, amountLeft: 100, ingredientClass: .Alcoholic,managedContext: managedContext!)
        Ingredient.newIngredient("Tequila", pumpNumber: 4, amountLeft: 50, ingredientClass: .Alcoholic, managedContext: managedContext!)
        Ingredient.newIngredient("Triple Sec", pumpNumber: 5, amountLeft: 50, ingredientClass: .Alcoholic,managedContext: managedContext!)
      
        Ingredient.newIngredient("Coca Cola", pumpNumber: 6, amountLeft: 400, ingredientClass: .NonAlcoholic, managedContext: managedContext!)
        Ingredient.newIngredient("Lemonade", pumpNumber: 7, amountLeft: 500, ingredientClass: .NonAlcoholic, managedContext: managedContext!)
        Ingredient.newIngredient("Orange Juice", pumpNumber: 8, amountLeft: 400, ingredientClass: .NonAlcoholic, managedContext: managedContext!)
        Ingredient.newIngredient("Cranberry Juice", pumpNumber: 9, amountLeft: 500, ingredientClass: .NonAlcoholic, managedContext: managedContext!)
        Ingredient.newIngredient("Lime Juice", pumpNumber: 10, amountLeft: 500, ingredientClass: .NonAlcoholic, managedContext: managedContext!)
    }
    
    class func createDrinkWithIngredient(name:String, imageName:String, ingredients: Dictionary<String, NSNumber>, managedContext: NSManagedObjectContext) -> Drink {
        var drink = Drink.newDrink(name, imageName: imageName, managedContext: managedContext)
        
        for (ingredientName, amountNeeded) in ingredients{
            drink.addIngredient(Ingredient.getIngredient(ingredientName, managedContext: managedContext)!, amount: amountNeeded)
        }
        
        Drink.save()
        return drink
    }
    
    class func initDatabase(managedContext: NSManagedObjectContext) {
        initIngredients()
        items.append(createDrinkWithIngredient("Long Island Ice Tea",
            imageName: "long-island-iced-tea",
            ingredients: ["Vodka": 15, "Light Rum": 15, "Tequila": 15, "Triple Sec": 15, "Gin": 15, "Coca Cola": 90]))
        
        items.append(createDrinkWithIngredient("Alpine Lemonade",
            imageName: "alpine-lemonade",
            ingredients: ["Vodka": 30, "Gin": 30, "Light Rum": 30, "Lemonade": 60, "Cranberry Juice": 60]))
        
        items.append(createDrinkWithIngredient("The Ollie",
            imageName: "the-ollie",
            ingredients: ["Vodka": 60, "Light Rum": 30, "Tequila": 30, "Lemonade": 150]))
        
        items.append(createDrinkWithIngredient("Cosmopolitan Classic",
            imageName: "cosmopolitan",
            ingredients: ["Vodka": 15, "Triple Sec": 15, "Cranberry Juice": 30, "Lime Juice": 15]))
        
        items.append(createDrinkWithIngredient("Margarita",
            imageName: "margarita",
            ingredients: ["Tequila": 30, "Triple Sec": 30, "Lime Juice": 15]))
        
        items.append(createDrinkWithIngredient("Vodka Cranberry",
            imageName: "vodka-cranberry",
            ingredients: ["Vodka": 30, "Cranberry Juice": 120, "Lime Juice": 15, "Orange Juice": 30]))
        
        items.append(createDrinkWithIngredient("Black Widow",
            imageName: "black-widow",
            ingredients: ["Vodka": 30, "Cranberry Juice": 30, "Lemonade": 30]))
        
        items.append(createDrinkWithIngredient("Rum and Coke",
            imageName: "rum-and-coke",
            ingredients: ["Light Rum": 30, "Coca Cola": 150]))
        
        items.append(createDrinkWithIngredient("Mix Your Own!!",
            imageName: "mix-your-own",
            ingredients: ["Light Rum": 0, "Vodka": 0, "Gin": 0, "Tequila": 0, "Triple Sec": 0, "Coca Cola": 0, "Lemonade": 0, "Orange Juice": 0, "Cranberry Juice": 0]))
        
        items.append(createDrinkWithIngredient("Hula-Hula",
            imageName: "hula-hula",
            ingredients: ["Gin": 60, "Orange Juice": 30, "Triple Sec": 7.5 ]))
        
        items.append(createDrinkWithIngredient("Kamikaze",
            imageName: "kamikaze",
            ingredients: ["Vodka": 15, "Triple Sec": 7.5]))
    
}
