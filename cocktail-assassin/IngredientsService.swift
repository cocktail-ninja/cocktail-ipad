//
//  IngredientsService.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 20/10/15.
//  Copyright © 2015 tw. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

class IngredientsService {
    
    class func getIngredients() -> Promise<[Any]> {
        let url = Constants.baseUrl.prod + "/ingredients"
        return Promise<[Any]> { fulfill, reject in
            Alamofire.request(.GET, url).responseJSON { (response) in
                print("Ingredients Responded!")
                switch response.result {
                case .Success(let value):
                    fulfill(value as! [Any])
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    class func assign(componentId: String, ingredient: String, amount: Int) -> Promise<Void>{
        let url = Constants.baseUrl.prod + "/assign/cid-\(componentId)/ingredient-\(ingredient)/amount-\(amount)"
        return Promise<Void> { fulfill, reject in
            Alamofire.request(.GET, url).responseJSON { (response) in
                switch response.result {
                case .Success:
                    fulfill()
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
}
