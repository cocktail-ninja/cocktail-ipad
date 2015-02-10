//
//  AppDelegate.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 20/1/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        var mainViewController = MainViewController();
        self.window!.rootViewController = mainViewController;
        self.window!.makeKeyAndVisible()
        self.window!.tintColor = ThemeColor.primary
        return true
    }
}

