//
//  DrinkCarouselItem.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 29/1/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit

class DrinkCarouselItem: UIView {
    var nameLabel = UILabel()
    var drinkImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(drinkImage)
        addSubview(nameLabel)
        
        nameLabel.frame = CGRectMake(0, frame.height - 40, frame.width, 40)
        nameLabel.textAlignment = .Center;
        nameLabel.font = UIFont(name: "Open Sans", size: 18)
      
        drinkImage.frame = CGRectMake(0, 0, frame.width, frame.height - nameLabel.frame.height)
        drinkImage.contentMode = .ScaleAspectFit
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDrink(drink: Drink){
        drinkImage.image = UIImage(named: drink.image)
        nameLabel.text = drink.name
    }
}
