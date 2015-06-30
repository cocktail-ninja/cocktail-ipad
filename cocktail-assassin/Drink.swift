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
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
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
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
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
    
    class func allDrinks (managedContext: NSManagedObjectContext) -> [Drink] {
        let fetchRequest = NSFetchRequest(entityName: "Drink")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending:true)]
        do {
            return try managedContext.executeFetchRequest(fetchRequest) as! [Drink]
        } catch {
            return [Drink]()
        }
    }
    
    class func getDrinkByName(name: String) -> Drink? {
        let fetchRequest = NSFetchRequest(entityName: "Drink")
        let managedContext = UIApplication.sharedDelegate().getManagedContext()

        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        do {
            let results = try managedContext?.executeFetchRequest(fetchRequest) as! [Drink]
            return results.first
        } catch {
            return nil
        }
    }
    
    class func revert() {
        let managedContext = UIApplication.sharedDelegate().getManagedContext()
        managedContext?.rollback();
    }

    class func save() {
        let managedContext = UIApplication.sharedDelegate().getManagedContext()
        do {
            try managedContext!.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}
