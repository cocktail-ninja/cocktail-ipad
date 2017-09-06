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

class DrinkController: WKInterfaceController {
    
    @IBOutlet weak var label: WKInterfaceLabel!
    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var button: WKInterfaceButton!
    var session: WCSession?
    
    var drink: Drink?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        drink = context as? Drink
    }
    
    override func willActivate() {
        label.setText(drink?.title)
        image.setImageNamed(drink?.image)
        
        session = WCSession.default()
        session!.delegate = self
        session!.activate()
        
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
                self.pushController(withName: "PourDrinkController", context: self.drink)
            },
            errorHandler: { (error) -> Void in
                puts("received error response! \(error)")
            }
        )
    }
    
}

extension DrinkController: WCSessionDelegate {
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith")
    }
    
}
