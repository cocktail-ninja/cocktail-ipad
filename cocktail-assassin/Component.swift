//
//  Component.swift
//  
//
//  Created by Colin Harris on 22/10/15.
//
//

import Foundation
import CoreData

@objc enum ComponentType: Int16 {
    case valve
    case pump
    
    func name() -> String {
        switch self {
            case .valve:
                return "Valve"
            case .pump:
                return "Pump"
        }
    }
}

class Component: NSManagedObject {
    
    static let EntityName = "Component"
    
    @NSManaged var name: String
    @NSManaged var id: String
    @NSManaged var type: ComponentType
    @NSManaged var ingredient: Ingredient?
    var selected: Bool = false
    
    class func newComponent(_ type: ComponentType, id: String, name: String, managedContext: NSManagedObjectContext) -> Component {
        let newIngredient = NSEntityDescription.insertNewObject(forEntityName: EntityName, into:managedContext) as! Component
        newIngredient.type = type
        newIngredient.id = id
        newIngredient.name = name
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save Ingredient \(error), \(error.userInfo)")
        }
        
        return newIngredient
    }
    
    class func all(_ managedContext: NSManagedObjectContext) -> [Component] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            return try managedContext.fetch(request) as! [Component]
        } catch {
            return [Component]()
        }
    }
    
    class func componentsOfType(_ type: ComponentType, managedContext: NSManagedObjectContext) -> [Component] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName)
        request.predicate = NSPredicate(format: "type = %@", argumentArray: [NSNumber(value: type.rawValue as Int16)])
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]        
        do {
            return try managedContext.fetch(request) as! [Component]
        } catch {
            return [Component]()
        }
    }
    
    class func componentMappedToIngredient(_ ingredient: Ingredient, context: NSManagedObjectContext) -> Component? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Component")
        request.predicate = NSPredicate(format: "ingredient = %@", ingredient)
        do {
            let results = try context.fetch(request) as! [Component]
            return results.first
        } catch {
            return nil
        }
    }
}
