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
        
        nameLabel.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 40)
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        
        imageView.frame =  CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        imageView.contentMode = .scaleAspectFit
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayDrink(_ drink: Drink) {
        imageView.image = drink.image()
        nameLabel.text = drink.name
    }
    
    func displayAddDrink() {
        imageView.image = UIImage(named: "add-drink")
        nameLabel.text = "Create Your Own"
    }
    
}
