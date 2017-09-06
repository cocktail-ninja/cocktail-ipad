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

class PourDrinkController: WKInterfaceController {
    
    @IBOutlet weak var label: WKInterfaceLabel!
    @IBOutlet weak var image: WKInterfaceImage!
    var session: WCSession?
    var drink: Drink?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        drink = context as? Drink
    }
    
    override func willActivate() {
        session = WCSession.default()
        session!.delegate = self
        session!.activate()
        
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("didReceiveMessage")
        self.pop()
    }
    
}

extension PourDrinkController: WCSessionDelegate {
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith")
    }
    
}
