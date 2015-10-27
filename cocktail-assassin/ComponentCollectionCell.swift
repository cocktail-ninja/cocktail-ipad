//
//  ComponentCollectionCell.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 27/10/15.
//  Copyright © 2015 tw. All rights reserved.
//

import UIKit

protocol ComponentCollectionCellDelegate {
    func componentClicked(component: Component)
}

class ComponentCollectionCell: UICollectionViewCell {
    
    @IBOutlet var button: UIButton!
    
    var component: Component?
    var delegate: ComponentCollectionCellDelegate?
    
    func update(component: Component) {
        self.component = component
        button.setTitle(component.name, forState: .Normal)
        self.layer.cornerRadius = 10.0
    }
    
    @IBAction func buttonClicked() {
        if let component = component {
            delegate?.componentClicked(component)
        }
    }
    
}