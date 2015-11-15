//
//  ComponentCollectionCell.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 27/10/15.
//  Copyright © 2015 tw. All rights reserved.
//

import UIKit

protocol ComponentCollectionCellDelegate {
    func componentSelected(component: Component)
}

class ComponentCollectionCell: UICollectionViewCell {
    
    @IBOutlet var button: UIButton!
    var buttonEnabled: Bool = true
    
    var component: Component?
    var delegate: ComponentCollectionCellDelegate?
    
    func update(component: Component) {
        self.component = component
        UIView.setAnimationsEnabled(false)
        button.setTitle(component.name, forState: .Normal)
        button.setBackgroundImage(self.imageFromColor(UIColor.blueColor()), forState: .Selected)
        self.button.selected = self.component!.selected
        self.layer.cornerRadius = 10.0
        UIView.setAnimationsEnabled(true)
    }
    
    func imageFromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    @IBAction func buttonClicked() {
        if let component = component {
            if buttonEnabled {
                component.selected = !component.selected
                button.selected = component.selected
                delegate?.componentSelected(component)
            }
        }
    }
    
}