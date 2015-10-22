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
    case Valve
    case Pump
    
    func name() -> String {
        switch self {
            case .Valve:
                return "Valve"
            case .Pump:
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

    class func newComponent(type: ComponentType, id: String, name: String, managedContext: NSManagedObjectContext) -> Component {
        let newIngredient = NSEntityDescription.insertNewObjectForEntityForName(EntityName, inManagedObjectContext:managedContext) as! Component
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
    
    class func all(managedContext: NSManagedObjectContext) -> [Component] {
        let fetchRequest = NSFetchRequest(entityName: EntityName)
        do {
            return try managedContext.executeFetchRequest(fetchRequest) as! [Component]
        } catch {
            return [Component]()
        }
    }
    
    class func componentsOfType(type: ComponentType, managedContext: NSManagedObjectContext) -> [Component] {
        let fetchRequest = NSFetchRequest(entityName: EntityName)
        fetchRequest.predicate = NSPredicate(format: "type = %@", argumentArray: [NSNumber(short: type.rawValue)])
        do {
            return try managedContext.executeFetchRequest(fetchRequest) as! [Component]
        } catch {
            return [Component]()
        }
    }
}
