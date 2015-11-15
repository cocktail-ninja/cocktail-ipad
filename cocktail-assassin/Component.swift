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
    var selected: Bool = false
    
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
        let request = NSFetchRequest(entityName: EntityName)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            return try managedContext.executeFetchRequest(request) as! [Component]
        } catch {
            return [Component]()
        }
    }
    
    class func componentsOfType(type: ComponentType, managedContext: NSManagedObjectContext) -> [Component] {
        let request = NSFetchRequest(entityName: EntityName)
        request.predicate = NSPredicate(format: "type = %@", argumentArray: [NSNumber(short: type.rawValue)])
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]        
        do {
            return try managedContext.executeFetchRequest(request) as! [Component]
        } catch {
            return [Component]()
        }
    }
}
