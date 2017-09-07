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
    case alcoholic
    case nonAlcoholic
}

enum IngredientType: String {
    // Valves
    case coke = "Coke"
    case lemonade = "Lemonade"
    case gingerBeer = "Ginger Beer"
    case cranberryJuice = "Cranberry Juice"
    case orangeJuice = "Orange Juice"
    // Pumps
    case limeJuice = "Lime Juice"
    case vodka = "Vodka"
    case gin = "Gin"
    case tequila = "Tequila"
    case lightRum = "Light Rum"
    case darkRum = "Dark Rum"
    case tripleSec = "Triple Sec"
}

class Ingredient: NSManagedObject {

    static let EntityName = "Ingredient"
    
    @NSManaged fileprivate var type: String
    @NSManaged var pumpNumber: NSNumber
    @NSManaged var amountLeft: NSNumber
    @NSManaged var drinkIngredients: NSSet
    @NSManaged var rawIngredientClass: Int16
    @NSManaged var component: Component?

    var ingredientClass: IngredientClass {
        get { return IngredientClass(rawValue: self.rawIngredientClass)! }
        set { self.rawIngredientClass = newValue.rawValue }
    }
    
    var ingredientType: IngredientType {
        return IngredientType(rawValue: type)!
    }
    
    var name: String {
        return ingredientType.rawValue
    }

    @discardableResult
    class func newIngredient(_ type: IngredientType,
                             pumpNumber: NSNumber,
                             amountLeft: NSNumber,
                             ingredientClass: IngredientClass,
                             managedContext: NSManagedObjectContext) -> Ingredient {
        let newIngredient = NSEntityDescription.insertNewObject(forEntityName: EntityName, into:managedContext) as! Ingredient
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
    
    class func getIngredient(_ type: IngredientType, managedContext: NSManagedObjectContext) -> Ingredient? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName)
        fetchRequest.predicate = NSPredicate(format: "type = %@", type.rawValue)
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results.first as? Ingredient
        } catch {
            return nil
        }
    }

    class func allIngredients(_ managedContext: NSManagedObjectContext) -> [Ingredient] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName)
        do {
            return try managedContext.fetch(fetchRequest) as! [Ingredient]
        } catch {
            return [Ingredient]()
        }
    }
    
    func isAlcoholic() -> Bool {
        return ingredientClass == .alcoholic
    }

}
