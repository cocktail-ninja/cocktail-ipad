//
//  DrinkIngredientCell.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 3/3/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit

class DrinkIngredientCell: UITableViewCell {

    var slider = UISlider()
    var ingredientNamelabel = UILabel()
    var ingredientAmountLabel = UILabel()
    var drinkIngredient: DrinkIngredient?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        addSubview(slider)
        addSubview(ingredientNamelabel)
        addSubview(ingredientAmountLabel)

        slider.frame = CGRectMake(255, 25, 250, 20)
        slider.addTarget(self, action: "sliderChanged", forControlEvents: .ValueChanged)
        
        ingredientNamelabel.frame = CGRectMake(0, 25, 160, 20)
        ingredientNamelabel.textAlignment = .Right
        ingredientNamelabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        
        ingredientAmountLabel.frame = CGRectMake(160, 25, 75, 20)
        ingredientAmountLabel.textAlignment = .Right
        ingredientAmountLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func sliderChanged() {
        drinkIngredient?.amount = (Int)(slider.value*200)
        ingredientAmountLabel.text = "\(drinkIngredient!.amount)ml"
    }
    
    func displayDrinkIngredient(drinkIngredient: DrinkIngredient) {
        self.drinkIngredient = drinkIngredient
        slider.setValue(drinkIngredient.amount.floatValue / 200, animated: false)
        ingredientNamelabel.text = drinkIngredient.ingredient.type
        ingredientAmountLabel.text = "\(self.drinkIngredient!.amount)ml"
    }
    
}
