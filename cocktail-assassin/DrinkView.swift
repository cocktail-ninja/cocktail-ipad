//
//  DrinkCarouselItem.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 29/1/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit

class DrinkView: UIView {
    var nameLabel = UILabel()
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(nameLabel)
        
        nameLabel.frame = CGRectMake(0, frame.height, frame.width, 40)
        nameLabel.textAlignment = .Center;
        nameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        
        imageView.frame =  CGRectMake(0, 0, frame.width, frame.height)
        imageView.contentMode = .ScaleAspectFit
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDrink(drink: Drink){
        imageView.image = UIImage(named: drink.imageName)
        nameLabel.text = drink.name
    }
}
