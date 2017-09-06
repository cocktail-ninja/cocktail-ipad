//
//  DrinkTotalCell.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 27/10/15.
//  Copyright © 2015 tw. All rights reserved.
//

import UIKit

class DrinkTotalCell: UITableViewCell {

    @IBOutlet var totalLabel: UILabel!    
    @IBOutlet var totalAmountLabel: UILabel!
 
    func update(_ drink: Drink) {
        let total = drink.total()
        totalAmountLabel.text = "\(total)ml"
        if total > DrinkService.maximumDrinkAmount() {
            totalLabel.textColor = ThemeColor.error
            totalAmountLabel.textColor = ThemeColor.error
        } else {
            totalLabel.textColor = UIColor.black
            totalAmountLabel.textColor = UIColor.black
        }
    }
    
}
