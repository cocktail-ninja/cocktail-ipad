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


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet weak var cocktailPicker: WKInterfacePicker?
    @IBOutlet weak var cocktailTable: WKInterfaceTable?
    var cocktails = [Drink]()
    var session: WCSession?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        cocktails = DrinkService().drinks
    }

    override func willActivate() {
        updateRows()
        
        session = WCSession.defaultSession()
        session!.delegate = self
        session!.activateSession()
        
        super.willActivate()
    }
    
    func updateRows() {
        cocktailTable?.setNumberOfRows(cocktails.count, withRowType: "CocktailRow")
        for (index, drink) in cocktails.enumerate() {
            let rowController = cocktailTable?.rowControllerAtIndex(index) as! CocktailRowController
            rowController.label.setText(drink.title)
            rowController.image.setImageNamed(drink.image)
        }
    }
    
    func sessionReachabilityDidChange(session: WCSession) {
        puts("sessionReachabilityDidChange")
    }
    
    override func didAppear() {
        super.didAppear()
        
//        session!.sendMessage(
//            ["request": "drinks"],
//            replyHandler: { (response) -> Void in
//                puts("received response! \(response)")
//                let drinkRecords = response["drinks"] as! [[String: String]]
//                self.cocktails = drinkRecords.map() { drinkData in
//                    return Drink(title: drinkData["title"]!, image: drinkData["image"]!)
//                }
//                self.updateRows()
//            },
//            errorHandler: { (error) -> Void in
//                puts("received error response! \(error)")
//            }
//        )
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        puts("didSelectRowAtIndex \(rowIndex)")
        let drink = cocktails[rowIndex]
        self.pushControllerWithName("DrinkController", context: drink)
    }

}
