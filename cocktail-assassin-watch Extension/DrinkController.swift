//
//  DrinkController.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 14/1/16.
//  Copyright © 2016 tw. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class DrinkController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var label: WKInterfaceLabel!
    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var button: WKInterfaceButton!
    var session: WCSession?
    
    var drink: Drink?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        drink = context as? Drink
    }
    
    override func willActivate() {
        label.setText(drink?.title)
        image.setImageNamed(drink?.image)
        
        session = WCSession.defaultSession()
        session!.delegate = self
        session!.activateSession()
        
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func pourDrink() {
        puts("pourDrink")
        session!.sendMessage(
            ["request": "pourDrink", "drinkName": drink!.title],
            replyHandler: { (response) -> Void in
                puts("received response! \(response)")
                self.pushControllerWithName("PourDrinkController", context: self.drink)
            },
            errorHandler: { (error) -> Void in
                puts("received error response! \(error)")
            }
        )
    }
    
}
