//
//  AppDelegate+ManagedContext.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 17/3/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit
import CoreData

extension AppDelegate {
    func getManagedContext() -> NSManagedObjectContext? {
        if let managedObjectContext = self.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }
}
