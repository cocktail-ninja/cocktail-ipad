//
//  DrinkService.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 20/1/16.
//  Copyright © 2016 tw. All rights reserved.
//

import Foundation
import WatchConnectivity

class DrinkService {
    
    var drinks = [Drink]()
    
    func loadDrinks(session: WCSession, callback: ((NSError?) -> Void)?) {
        session.sendMessage(
            ["request": "drinks"],
            replyHandler: { (response) -> Void in
                puts("received response! \(response)")
                let drinkRecords = response["drinks"] as! [[String: String]]
                let newDrinks = drinkRecords.map() { drinkData in
                    return Drink(title: drinkData["title"]!, image: drinkData["image"]!)
                }
                self.drinks = newDrinks.filter() { drink in
                    return drink.title != "Mix Your Own!!"
                }
                callback?(nil)
            },
            errorHandler: { (error) -> Void in
                puts("received error response! \(error)")
                callback?(error)
            }
        )
    }
    
}
