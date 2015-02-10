//
//  DrinkService.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 10/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//


class DrinkService: NSObject {
    class func makeDrink(#recipe: String, onSuccess: (() -> Void)?, onFailure: (() -> Void)?){
        request(.POST, Constants.baseUrl.dev + "/make_drink/" + recipe)
            .response { (request, response, data, error) in
                println(request, response, data, error)
                if (response?.statusCode == 200){
                    onSuccess?()
                } else {
                    onFailure?()
                }
            }
    }
}
