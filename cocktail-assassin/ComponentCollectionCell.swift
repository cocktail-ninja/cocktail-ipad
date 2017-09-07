//
//  ComponentCollectionCell.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 27/10/15.
//  Copyright © 2015 tw. All rights reserved.
//

import UIKit

protocol ComponentCollectionCellDelegate: class {
    func componentSelected(_ component: Component)
}

class ComponentCollectionCell: UICollectionViewCell {
    
    @IBOutlet var button: UIButton!
    var buttonEnabled: Bool = true
    
    var component: Component?
    weak var delegate: ComponentCollectionCellDelegate?
    
    func update(_ component: Component) {
        self.component = component
        UIView.setAnimationsEnabled(false)
        button.setTitle(component.name, for: UIControlState())
        button.setBackgroundImage(self.imageFromColor(UIColor.blue), for: .selected)
        self.button.isSelected = self.component!.selected
        self.layer.cornerRadius = 10.0
        UIView.setAnimationsEnabled(true)
    }
    
    func imageFromColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    @IBAction func buttonClicked() {
        if let component = component {
            if buttonEnabled {
                component.selected = !component.selected
                button.isSelected = component.selected
                delegate?.componentSelected(component)
            }
        }
    }
    
}
