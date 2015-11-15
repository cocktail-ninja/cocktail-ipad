//
//  ComponentMappingCell.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 16/11/15.
//  Copyright © 2015 tw. All rights reserved.
//

import UIKit

class ComponentMappingCell: UICollectionViewCell {
    
    @IBOutlet var button: UIButton!
    @IBOutlet var ingredientLabel: UILabel!
    
    var component: Component?
    var delegate: ComponentCollectionCellDelegate?
    
    func update(component: Component) {
        self.component = component
        UIView.setAnimationsEnabled(false)
        button.setTitle(component.name, forState: .Normal)
        ingredientLabel.text = component.ingredient?.name ?? ""
        self.layer.cornerRadius = 10.0
        UIView.setAnimationsEnabled(true)
    }
    
    @IBAction func buttonClicked() {
        if let component = component {
            delegate?.componentSelected(component)
        }
    }
    
}
