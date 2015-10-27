//
//  Drink.swift
//  CocktailData
//
//  Created by Colin Harris on 10/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class Drink: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var imageName: String
    @NSManaged var editable: Bool
    @NSManaged var drinkIngredients: NSSet

    class func newDrink(name: String, imageName: String, editable: Bool, managedContext: NSManagedObjectContext) -> Drink {
        let newDrink = NSEntityDescription.insertNewObjectForEntityForName("Drink", inManagedObjectContext:managedContext) as! Drink
        newDrink.name = name
        newDrink.saveImage(UIImage(named: imageName)!)
        newDrink.editable = editable
        return newDrink
    }
    
    func saveImage(image: UIImage) {
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
        var identifier = self.objectID.URIRepresentation().absoluteString
        identifier = identifier.stringByReplacingOccurrencesOfString("x-coredata://", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        identifier = identifier.stringByReplacingOccurrencesOfString("/", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let imageName = "\(identifier).png"
        let imagePath = documentPath.stringByAppendingPathComponent(imageName)
        let imageData = UIImagePNGRepresentation(image)
        imageData!.writeToFile(imagePath, atomically:true)
        self.imageName = imageName
    }
    
    func image() -> UIImage {
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
        let imagePath = documentPath.stringByAppendingPathComponent(self.imageName)
        return UIImage(contentsOfFile: imagePath)!
    }
    
    func addIngredient(ingredient: Ingredient, amount: NSNumber) {
        DrinkIngredient.newDrinkIngredient(self, ingredient: ingredient, amount: amount, managedContext: self.managedObjectContext!)
    }

    func removeDrinkIngredient(drinkIngredient: DrinkIngredient) {
        self.managedObjectContext?.deleteObject(drinkIngredient)
        self.managedObjectContext?.processPendingChanges()
    }
    
    func hasIngredient(ingredient: Ingredient) -> Bool {
        for drinkIngredient in self.drinkIngredients {
            if (drinkIngredient as! DrinkIngredient).ingredient == ingredient {
                return true
            }
        }
        return false
    }
    
    class func allDrinks(context: NSManagedObjectContext) -> [Drink] {
        let request = NSFetchRequest(entityName: "Drink")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending:true)]
        do {
            return try context.executeFetchRequest(request) as! [Drink]
        } catch {
            return [Drink]()
        }
    }
    
    class func getDrinkByName(name: String, context: NSManagedObjectContext) -> Drink? {
        let request = NSFetchRequest(entityName: "Drink")
        request.predicate = NSPredicate(format: "name = %@", name)
        do {
            let results = try context.executeFetchRequest(request) as! [Drink]
            return results.first
        } catch {
            return nil
        }
    }
 
    func total() -> Int {
        let ingredients = drinkIngredients.allObjects as! [DrinkIngredient]
        return ingredients.reduce(0) { total, ingredient in
            return total + ingredient.amount.integerValue
        }
    }
    
}
