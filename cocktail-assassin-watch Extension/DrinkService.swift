//
//  DrinkService.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 20/1/16.
//  Copyright © 2016 tw. All rights reserved.
//

import Foundation
class DrinkService {
    
    var drinks = [Drink]()
    
    init() {
        drinks.append(Drink(title: "Long Island Ice Tea", image: "long-island-iced-tea"))
        drinks.append(Drink(title: "Alpine Lemonade", image: "alpine-lemonade"))
        drinks.append(Drink(title: "The Ollie", image: "the-ollie"))
        drinks.append(Drink(title: "Cosmopolitan Classic", image: "cosmopolitan"))
        drinks.append(Drink(title: "Margarita", image: "margarita"))
        drinks.append(Drink(title: "Vodka Cranberry", image: "vodka-cranberry"))
        drinks.append(Drink(title: "Black Widow", image: "black-widow"))
        drinks.append(Drink(title: "Rum and Coke", image: "rum-and-coke"))
        //drinks.append(Drink(title: "Mix Your Own!!", image: "mix-your-own"))
        drinks.append(Drink(title: "Hula-Hula", image: "hula-hula"))
        drinks.append(Drink(title: "Kamikaze", image: "kamikaze"))
    }
    
}
