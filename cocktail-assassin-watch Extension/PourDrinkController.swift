//
//  PourDrinkController.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 20/1/16.
//  Copyright © 2016 tw. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class PourDrinkController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var label: WKInterfaceLabel!
    @IBOutlet weak var image: WKInterfaceImage!
    var session: WCSession?
    var drink: Drink?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        drink = context as? Drink
    }
    
    override func willActivate() {
        session = WCSession.defaultSession()
        session!.delegate = self
        session!.activateSession()
        
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        print("didReceiveMessage")
        self.popController()
    }
    
}
