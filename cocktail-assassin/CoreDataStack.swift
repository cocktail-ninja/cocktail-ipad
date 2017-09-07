//
//  CoreDataStack.swift
//
//  Created by Colin Harris on 21/5/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

import Foundation
import CoreData

open class CoreDataStack {
    
    open var context: NSManagedObjectContext!
    fileprivate var privateContext: NSManagedObjectContext!
    fileprivate var initCallback: () -> Void
    fileprivate var bundleIdentifier = "com.twsg.cocktail-assassin"
    fileprivate var dataModelName = "CocktailAssassin"
    
    public init(callback: @escaping () -> Void) {
        self.initCallback = callback
        self.initializeCoreData()
    }
    
    open func save() {
        if !privateContext.hasChanges && !context.hasChanges {
            print("CoreDataStack: No changes to be saved.")
            return
        }
        
        context.performAndWait({
            do {
                try self.context.save()
            } catch {
                assert(false, "Error saving main context")
            }
            
            self.privateContext.perform({
                do {
                    try self.privateContext.save()
                } catch {
                    assert(false, "Error saving private context")
                }
            })
        })
    }
    
    open func reset() {
        context.reset()
    }

    open func revert() {
        context.rollback()
    }
    
    open func save(_ context: NSManagedObjectContext) {
        if !privateContext.hasChanges && !context.hasChanges {
            print("CoreDataStack: No changes to be saved.")
            return
        }
        
        context.performAndWait({
            do {
                try context.save()
            } catch {
                assert(false, "Error saving a context")
            }
            
            self.privateContext.perform({
                do {
                    try self.privateContext.save()
                } catch {
                    assert(false, "Error saving private context")
                }
            })
        })
        
    }
    
    open func createNewContext() -> NSManagedObjectContext {
        let newContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        newContext.persistentStoreCoordinator = privateContext.persistentStoreCoordinator
        return newContext
    }
    
    fileprivate func initializeCoreData() {
        if context != nil {
            return
        }
        let modelURL = Bundle(identifier: bundleIdentifier)?.url(forResource: dataModelName, withExtension: "momd")
        let mom = NSManagedObjectModel(contentsOf:modelURL!)
        assert(mom != nil, "No model to generate a store from")
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: mom!)

        privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext?.persistentStoreCoordinator = coordinator

        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = privateContext
        
        DispatchQueue.global(qos: .background).async {
            let psc = self.privateContext.persistentStoreCoordinator
            var options = [String: Any]()
            options[NSMigratePersistentStoresAutomaticallyOption] = true as AnyObject
            options[NSInferMappingModelAutomaticallyOption] = true as AnyObject
            options[NSSQLitePragmasOption] = ["journal_mode": "DELETE"]
            
            let documentsDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            )[0] as URL
            let storeURL = documentsDirectory.appendingPathComponent("\(self.dataModelName).sqlite")
            print("Persistent Store URL: \(storeURL)")
            
            do {
                try psc?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
            } catch {
                assert(false, "Error initializing persistent store coordinator")
            }
            
            DispatchQueue.main.sync {
                self.initCallback()
            }
        }
        
    }
    
    open func executeFetchRequest(_ request: NSFetchRequest<NSFetchRequestResult>) throws -> [AnyObject]? {
        return try context.fetch(request)
    }

    open func performBackgroundOperation(_ operationBlock: @escaping ((_ context: NSManagedObjectContext) -> Void)) {
        let temporaryContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        temporaryContext.parent = context

        temporaryContext.perform {
            operationBlock(temporaryContext)

            do {
                try temporaryContext.save()
            } catch {
                assert(false, "Error saving temporary/background context")
            }
            
            // Save the main context and write to disk
            self.save()
        }                
    }
    
}
