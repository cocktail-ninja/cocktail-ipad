//
//  InterfaceController.swift
//  cocktail-assassin-watch Extension
//
//  Created by Colin Harris on 13/1/16.
//  Copyright © 2016 tw. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var cocktailPicker: WKInterfacePicker?
    @IBOutlet weak var cocktailTable: WKInterfaceTable?
    var cocktails = [Drink]()
    let drinkService = DrinkService()
    var session: WCSession?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        cocktails = drinkService.drinks
    }

    override func willActivate() {
        updateRows()
        
        session = WCSession.default()
        session!.delegate = self
        session!.activate()
        
        super.willActivate()
    }
    
    func updateRows() {
        cocktailTable?.setNumberOfRows(cocktails.count, withRowType: "CocktailRow")
        for (index, drink) in cocktails.enumerated() {
            let rowController = cocktailTable?.rowController(at: index) as! CocktailRowController
            rowController.label.setText(drink.title)
            rowController.image.setImageNamed(drink.image)
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        puts("sessionReachabilityDidChange")
    }
    
    override func didAppear() {
        super.didAppear()
        
        drinkService.loadDrinks(session!) { error in
            if let error = error {
                print("Failed to load drinks. Error: \(error.localizedDescription)")
            } else {
                print("Updating drink list")
                self.cocktails = self.drinkService.drinks
                self.updateRows()
            }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        puts("didSelectRowAtIndex \(rowIndex)")
        let drink = cocktails[rowIndex]
        self.pushController(withName: "DrinkController", context: drink)
    }

}

extension InterfaceController: WCSessionDelegate {
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith")
    }
    
}
