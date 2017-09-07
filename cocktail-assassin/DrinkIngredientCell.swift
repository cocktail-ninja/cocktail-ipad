import UIKit

protocol RemoveIngredientDelegate: class {
    func removeDrinkIngredient(_ ingredient: DrinkIngredient)
    func amountChanged(_ ingredient: DrinkIngredient)
}

class DrinkIngredientCell: UITableViewCell {
    
    @IBOutlet var slider: UISlider?
    @IBOutlet var ingredientNameLabel: UILabel!
    @IBOutlet var ingredientAmountLabel: UILabel!
    @IBOutlet var removeButton: UIButton?
    @IBOutlet var drinkNotesLabel: UILabel?
    
    var drinkIngredient: DrinkIngredient?
    weak var delegate: RemoveIngredientDelegate?
    var editMode = false
    var increment: Int = 15
    
    override func layoutSubviews() {
        super.layoutSubviews()

        slider?.addTarget(self, action: #selector(DrinkIngredientCell.sliderChanged), for: .valueChanged)
        
        drinkNotesLabel?.textColor = ThemeColor.primary
        drinkNotesLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        drinkNotesLabel?.textAlignment = .left
        drinkNotesLabel?.isHidden = true
        
        removeButton?.isHidden = !editMode
        removeButton?.addTarget(self, action: #selector(DrinkIngredientCell.removeClicked), for: .touchUpInside)
    }
    
    @IBAction func removeClicked() {
        delegate?.removeDrinkIngredient(drinkIngredient!)
    }

    @IBAction func sliderChanged() {
        if let slider = slider {
            let value = Int(slider.value + Float(increment / 2))
            let adjustedValue = (value / increment) * increment
            slider.setValue(Float(adjustedValue), animated: true)
            drinkIngredient?.amount = NSNumber(value: slider.value)            
        }
        ingredientAmountLabel.text = "\(drinkIngredient!.amount)ml"
        delegate?.amountChanged(drinkIngredient!)
    }
    
    func displayDrinkIngredient(_ drinkIngredient: DrinkIngredient) {
        self.drinkIngredient = drinkIngredient
        ingredientNameLabel.text = drinkIngredient.ingredient.ingredientType.rawValue
        ingredientAmountLabel.text = "\(self.drinkIngredient!.amount)ml"
        removeButton?.isHidden = !editMode
        
        if drinkIngredient.ingredient.ingredientClass == .alcoholic {
            slider?.minimumValue = 0
            slider?.maximumValue = 90
            increment = 5
        } else {
            slider?.minimumValue = 0
            slider?.maximumValue = 200
            increment = 10
        }
        
        slider?.setValue(drinkIngredient.amount.floatValue, animated: false)
    }
    
}
