//
//  Ingredient.swift
//  CocktailData
//
//  Created by Colin Harris on 10/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

import Foundation
import CoreData

enum IngredientClass: Int16 {
    case Alcoholic
    case NonAlcoholic
}

class Ingredient: NSManagedObject {

    @NSManaged var type: String
    @NSManaged var pumpNumber: NSNumber
    @NSManaged var amountLeft: NSNumber
    @NSManaged var drinkIngredients: NSSet
    @NSManaged var rawIngredientClass: Int16

    var ingredientClass:IngredientClass {
        get { return IngredientClass(rawValue: self.rawIngredientClass)! }
        set { self.rawIngredientClass = newValue.rawValue }
    }

    class func newIngredient(type: String, pumpNumber: NSNumber, amountLeft: NSNumber, ingredientClass: IngredientClass, managedContext: NSManagedObjectContext) -> Ingredient {
        var newIngredient = NSEntityDescription.insertNewObjectForEntityForName("Ingredient", inManagedObjectContext:managedContext) as! Ingredient
        newIngredient.type = type
        newIngredient.pumpNumber = pumpNumber
        newIngredient.amountLeft = amountLeft
        newIngredient.ingredientClass = ingredientClass
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save Ingredient \(error), \(error?.userInfo)")
        }

        return newIngredient
    }
    
    class func getIngredient(type: String, managedContext: NSManagedObjectContext) -> Ingredient?{
        let fetchRequest = NSFetchRequest(entityName: "Ingredient")
        fetchRequest.predicate = NSPredicate(format: "type = %@", type)
        return (managedContext.executeFetchRequest(fetchRequest, error: nil) as! [Ingredient]).first
    }

    class func allIngredients(managedContext: NSManagedObjectContext) -> [Ingredient] {
        let fetchRequest = NSFetchRequest(entityName: "Ingredient")
        return managedContext.executeFetchRequest(fetchRequest, error: nil) as! [Ingredient]
    }

}
