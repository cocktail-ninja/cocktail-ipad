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
        let newIngredient = NSEntityDescription.insertNewObjectForEntityForName("Ingredient", inManagedObjectContext:managedContext) as! Ingredient
        newIngredient.type = type
        newIngredient.pumpNumber = pumpNumber
        newIngredient.amountLeft = amountLeft
        newIngredient.ingredientClass = ingredientClass
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save Ingredient \(error), \(error.userInfo)")
        }

        return newIngredient
    }
    
    class func getIngredient(type: String, managedContext: NSManagedObjectContext) -> Ingredient? {
        let fetchRequest = NSFetchRequest(entityName: "Ingredient")
        fetchRequest.predicate = NSPredicate(format: "type = %@", type)
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest) as! [Ingredient]
            return results.first
        } catch {
            return nil
        }
    }

    class func allIngredients(managedContext: NSManagedObjectContext) -> [Ingredient] {
        let fetchRequest = NSFetchRequest(entityName: "Ingredient")
        do {
            return try managedContext.executeFetchRequest(fetchRequest) as! [Ingredient]
        } catch {
            return [Ingredient]()
        }
    }

}
