//
//  CoreDataStack.swift
//
//  Created by Colin Harris on 21/5/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack {
    
    public var context: NSManagedObjectContext!
    private var privateContext : NSManagedObjectContext!
    private var initCallback : () -> ()
    private var bundleIdentifier = "com.twsg.cocktail-assassin"
    private var dataModelName = "CocktailAssassin"
    
    public init(callback: () -> () ) {
        self.initCallback = callback
        self.initializeCoreData()
    }
    
    public func save() {
        if !privateContext.hasChanges && !context.hasChanges {
            print("CoreDataStack: No changes to be saved.")
            return
        }
        
        context.performBlockAndWait({
            do {
                try self.context.save()
            } catch {
                assert(false, "Error saving main context")
            }
            
            self.privateContext.performBlock({
                do {
                    try self.privateContext.save()
                } catch {
                    assert(false, "Error saving private context")
                }
            })
        })
    }
    
    public func reset() {
        context.reset()
    }
    
    public func save(context: NSManagedObjectContext) {
        if !privateContext.hasChanges && !context.hasChanges {
            print("CoreDataStack: No changes to be saved.")
            return
        }
        
        context.performBlockAndWait({
            do {
                try context.save()
            } catch {
                assert(false, "Error saving a context")
            }
            
            self.privateContext.performBlock({
                do {
                    try self.privateContext.save()
                } catch {
                    assert(false, "Error saving private context")
                }
            })
        })
        
    }
    
    public func createNewContext() -> NSManagedObjectContext {
        let newContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        newContext.persistentStoreCoordinator = privateContext.persistentStoreCoordinator
        return newContext
    }
    
    private func initializeCoreData() {
        if context != nil {
            return
        }
        let modelURL = NSBundle(identifier: bundleIdentifier)?.URLForResource(dataModelName, withExtension: "momd")
        let mom = NSManagedObjectModel(contentsOfURL:modelURL!)
        assert(mom != nil, "No model to generate a store from")
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: mom!)

        privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext?.persistentStoreCoordinator = coordinator

        context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.parentContext = privateContext
        
        let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let psc = self.privateContext.persistentStoreCoordinator
            var options = [String: AnyObject]()
            options[NSMigratePersistentStoresAutomaticallyOption] = true
            options[NSInferMappingModelAutomaticallyOption] = true
            options[NSSQLitePragmasOption] = [ "journal_mode" : "DELETE" ]
            
            let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(
                .DocumentDirectory,
                inDomains: .UserDomainMask
            )[0] as NSURL
            let storeURL = documentsDirectory.URLByAppendingPathComponent("\(self.dataModelName).sqlite")
            print("Persistent Store URL: \(storeURL)")
            
            do {
                try psc?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
            } catch {
                assert(false, "Error initializing persistent store coordinator");
            }
            
            dispatch_sync(dispatch_get_main_queue()) {
                self.initCallback()
            }
        }
        
    }
    
    public func executeFetchRequest(request: NSFetchRequest) throws -> [AnyObject]? {
        return try context.executeFetchRequest(request)
    }

    public func performBackgroundOperation(operationBlock: ((context: NSManagedObjectContext) -> Void)) {
        let temporaryContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        temporaryContext.parentContext = context

        temporaryContext.performBlock() {
            operationBlock(context: temporaryContext)

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