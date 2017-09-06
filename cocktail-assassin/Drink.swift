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
    @NSManaged var origImageName: String
    @NSManaged var editable: Bool
    @NSManaged var drinkIngredients: NSSet

    class func newDrink(_ name: String, imageName: String, editable: Bool, managedContext: NSManagedObjectContext) -> Drink {
        let newDrink = NSEntityDescription.insertNewObject(forEntityName: "Drink", into:managedContext) as! Drink
        newDrink.name = name
        newDrink.origImageName = imageName
        newDrink.saveImage(UIImage(named: imageName)!)
        newDrink.editable = editable
        return newDrink
    }
    
    func saveImage(_ image: UIImage) {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        var identifier = self.objectID.uriRepresentation().absoluteString
        identifier = identifier.replacingOccurrences(of: "x-coredata://", with: "", options: NSString.CompareOptions.literal, range: nil)
        identifier = identifier.replacingOccurrences(of: "/", with: "-", options: NSString.CompareOptions.literal, range: nil)
        let imageName = "\(identifier).png"
        let imagePath = documentPath.appendingPathComponent(imageName)
        let imageData = UIImagePNGRepresentation(image)
        try? imageData!.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
        self.imageName = imageName
    }
    
    func image() -> UIImage {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        let imagePath = documentPath.appendingPathComponent(self.imageName)
        return UIImage(contentsOfFile: imagePath)!
    }
    
    func addIngredient(_ ingredient: Ingredient, amount: NSNumber) {
        DrinkIngredient.newDrinkIngredient(self, ingredient: ingredient, amount: amount, managedContext: self.managedObjectContext!)
    }

    func containsIngredient(_ ingredient: Ingredient) -> Bool {
        let ingredients = self.drinkIngredients.map() { ($0 as! DrinkIngredient).ingredient } as [Ingredient]
        return ingredients.contains(ingredient)
    }
    
    func removeDrinkIngredient(_ drinkIngredient: DrinkIngredient) {
        self.managedObjectContext?.delete(drinkIngredient)
        self.managedObjectContext?.processPendingChanges()
    }
    
    func hasIngredient(_ ingredient: Ingredient) -> Bool {
        for drinkIngredient in self.drinkIngredients {
            if (drinkIngredient as! DrinkIngredient).ingredient == ingredient {
                return true
            }
        }
        return false
    }
    
    class func allDrinks(_ context: NSManagedObjectContext) -> [Drink] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Drink")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending:true)]
        do {
            return try context.fetch(request) as! [Drink]
        } catch {
            return [Drink]()
        }
    }
    
    class func getDrinkByName(_ name: String, context: NSManagedObjectContext) -> Drink? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Drink")
        request.predicate = NSPredicate(format: "name = %@", name)
        do {
            let results = try context.fetch(request) as! [Drink]
            return results.first
        } catch {
            return nil
        }
    }
 
    func total() -> Int {
        let ingredients = drinkIngredients.allObjects as! [DrinkIngredient]
        return ingredients.reduce(0) { total, ingredient in
            return total + ingredient.amount.intValue
        }
    }
    
}
