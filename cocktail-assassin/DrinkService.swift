//
//  DrinkService.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 10/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import Foundation
import PromiseKit

class DrinkService: NSObject {
    class func makeDrink(#recipe: String) -> Promise<Double> {
        var url = Constants.baseUrl.dev + "/make_drink/" + recipe
        return NSURLConnection.POST(url, JSON: [String: String]())
            .then { (result : NSDictionary) -> Promise<Double> in
                var readyInDuration = (result.objectForKey("ready_in") as Double) / 1000
                
                return Promise<Double>(value: readyInDuration)
                
        }
    }
}
