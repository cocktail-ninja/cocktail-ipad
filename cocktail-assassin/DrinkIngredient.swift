//
//  DrinkIngredient.swift
//  CocktailData
//
//  Created by Colin Harris on 10/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

import Foundation
import CoreData

class DrinkIngredient: NSManagedObject {

    @NSManaged var amount: NSNumber
    @NSManaged var drink: Drink
    @NSManaged var ingredient: Ingredient

    class func newDrinkIngredient(_ drink: Drink, ingredient: Ingredient, amount: NSNumber, managedContext: NSManagedObjectContext) -> DrinkIngredient {
        let newDrinkIngredient = NSEntityDescription.insertNewObject(forEntityName: "DrinkIngredient", into:managedContext) as! DrinkIngredient
        newDrinkIngredient.drink = drink
        newDrinkIngredient.ingredient = ingredient
        newDrinkIngredient.amount = amount
        return newDrinkIngredient
    }
    
}
