//
//  Drink.swift
//  CocktailData
//
//  Created by Colin Harris on 10/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

import Foundation
import CoreData

class Drink: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var imageName: String
    @NSManaged var drinkIngredients: NSSet

    class func newDrink(name: String, imageName: String, managedContext: NSManagedObjectContext) -> Drink {
        var newDrink = NSEntityDescription.insertNewObjectForEntityForName("Drink", inManagedObjectContext:managedContext) as Drink
        newDrink.name = name
        newDrink.imageName = imageName
        return newDrink
    }
    
    func addIngredient(ingredient: Ingredient, amount: NSNumber) {
        DrinkIngredient.newDrinkIngredient(self, ingredient: ingredient, amount: amount, managedContext: self.managedObjectContext!)
        
        var error: NSError?
        if !self.managedObjectContext!.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    class func allDrinks (managedContext: NSManagedObjectContext) -> [Drink]{
        let fetchRequest = NSFetchRequest(entityName: "Drink")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending:true)]
        return managedContext.executeFetchRequest(fetchRequest, error: nil) as [Drink]
    }
    
}
