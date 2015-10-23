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

enum IngredientType: String {
    // Valves
    case Coke = "Coke"
    case Lemonade = "Lemonade"
    case GingerBeer = "Ginger Beer"
    case CranberryJuice = "Cranberry Juice"
    case OrangeJuice = "Orange Juice"
    // Pumps
    case LimeJuice = "Lime Juice"
    case Vodka = "Vodka"
    case Gin = "Gin"
    case Tequila = "Tequila"
    case LightRum = "Light Rum"
    case DarkRum = "Dark Rum"
    case TripleSec = "Triple Sec"
}

class Ingredient: NSManagedObject {

    static let EntityName = "Ingredient"
    
    @NSManaged private var type: String
    @NSManaged var pumpNumber: NSNumber
    @NSManaged var amountLeft: NSNumber
    @NSManaged var drinkIngredients: NSSet
    @NSManaged var rawIngredientClass: Int16
    @NSManaged var component: Component?

    var ingredientClass:IngredientClass {
        get { return IngredientClass(rawValue: self.rawIngredientClass)! }
        set { self.rawIngredientClass = newValue.rawValue }
    }
    
    var ingredientType: IngredientType {
        get {
            return IngredientType(rawValue: type)!
        }
    }

    class func newIngredient(type: IngredientType, pumpNumber: NSNumber, amountLeft: NSNumber, ingredientClass: IngredientClass, managedContext: NSManagedObjectContext) -> Ingredient {
        let newIngredient = NSEntityDescription.insertNewObjectForEntityForName(EntityName, inManagedObjectContext:managedContext) as! Ingredient
        newIngredient.type = type.rawValue
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
    
    class func getIngredient(type: IngredientType, managedContext: NSManagedObjectContext) -> Ingredient? {
        let fetchRequest = NSFetchRequest(entityName: EntityName)
        fetchRequest.predicate = NSPredicate(format: "type = %@", type.rawValue)
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest) as! [Ingredient]
            return results.first
        } catch {
            return nil
        }
    }

    class func allIngredients(managedContext: NSManagedObjectContext) -> [Ingredient] {
        let fetchRequest = NSFetchRequest(entityName: EntityName)
        do {
            return try managedContext.executeFetchRequest(fetchRequest) as! [Ingredient]
        } catch {
            return [Ingredient]()
        }
    }

}
