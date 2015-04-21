//
//  DrinkService.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 10/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

class DrinkService: NSObject {
    
    class func makeDrink(#recipe: String) -> Promise<Double> {
        var url = Constants.baseUrl.prod + "/make_drink/" + recipe
        
        return Promise<Double> { deferred in
            Alamofire.request(.POST, url)
                .responseJSON { (request, response, data, error) in
                    if let anError = error  {
                        deferred.reject(anError)                        
                    } else if response?.statusCode == 200 {
                        var readyIn = (data as! NSDictionary)["ready_in"] as! Double / 1000
                        NSLog("Ready In: \(readyIn)")
                        deferred.fulfill(readyIn)
                    } else {
                        var statusError = NSError(domain: "DrinkService", code: response!.statusCode, userInfo: nil)
                        deferred.reject(statusError)
                    }
            }
            return
        }
        
    }
    
}
