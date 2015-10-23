
import UIKit

protocol RemoveIngredientDelegate {
    func removeDrinkIngredient(ingredient: DrinkIngredient)
}

class DrinkIngredientCell: UITableViewCell {
    
    @IBOutlet var slider: UISlider!
    @IBOutlet var ingredientNameLabel: UILabel!
    @IBOutlet var ingredientAmountLabel: UILabel!
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var drinkNotesLabel: UILabel?
    
    var drinkIngredient: DrinkIngredient?
    var delegate: RemoveIngredientDelegate?
    var editMode = false
    var increment: Int = 15
    
    override func layoutSubviews() {
        super.layoutSubviews()

        slider.addTarget(self, action: "sliderChanged", forControlEvents: .ValueChanged)
        
        drinkNotesLabel?.textColor = ThemeColor.primary
        drinkNotesLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        drinkNotesLabel?.textAlignment = .Left
        drinkNotesLabel?.hidden = true
        
        removeButton.hidden = !editMode
        removeButton.addTarget(self, action: "removeClicked", forControlEvents: .TouchUpInside)
    }
    
    @IBAction func removeClicked() {
        delegate?.removeDrinkIngredient(drinkIngredient!)
    }

    @IBAction func sliderChanged() {
        let value = Int(slider.value + Float(increment / 2))
        let adjustedValue = (value / increment) * increment
        slider.setValue(Float(adjustedValue), animated: true)
        
        drinkIngredient?.amount = (Int)(slider.value)
        ingredientAmountLabel.text = "\(drinkIngredient!.amount)ml"
    }
    
    func displayDrinkIngredient(drinkIngredient: DrinkIngredient) {
        self.drinkIngredient = drinkIngredient
        ingredientNameLabel.text = drinkIngredient.ingredient.ingredientType.rawValue
        ingredientAmountLabel.text = "\(self.drinkIngredient!.amount)ml"
        removeButton.hidden = !editMode        
        slider.hidden = false
        ingredientAmountLabel.hidden = false
        
        if (drinkIngredient.ingredient.ingredientClass == .Alcoholic) {
            slider.minimumValue = 0
            slider.maximumValue = 90
            increment = 5
        } else {
            slider.minimumValue = 0
            slider.maximumValue = 180
            increment = 10
        }
        
        slider.setValue(drinkIngredient.amount.floatValue, animated: false)
    }
    
}
