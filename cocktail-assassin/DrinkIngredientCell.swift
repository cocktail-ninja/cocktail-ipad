
import UIKit

protocol RemoveIngredientDelegate {
    func removeDrinkIngredient(ingredient: DrinkIngredient)
}

class DrinkIngredientCell: UITableViewCell {
    var slider = FixedIncrementSlider(frame: CGRectMake(255, 25, 250, 20))
    var ingredientNamelabel = UILabel()
    var ingredientAmountLabel = UILabel()
    var drinkNotesLabel = UILabel()
    var removeButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    var drinkIngredient: DrinkIngredient?
    var delegate: RemoveIngredientDelegate?
    var editMode = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        addSubview(slider)
        addSubview(ingredientNamelabel)
        addSubview(ingredientAmountLabel)
        addSubview(removeButton)
        addSubview(drinkNotesLabel)

        slider.addTarget(self, action: "sliderChanged", forControlEvents: .ValueChanged)
        
        ingredientNamelabel.frame = CGRectMake(0, 25, 160, 20)
        ingredientNamelabel.textAlignment = .Right
        ingredientNamelabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        
        ingredientAmountLabel.frame = CGRectMake(160, 25, 75, 20)
        ingredientAmountLabel.textAlignment = .Right
        ingredientAmountLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        
        drinkNotesLabel.frame = CGRectMake(200, 25, 325, 20)
        drinkNotesLabel.textColor = ThemeColor.primary
        drinkNotesLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        drinkNotesLabel.textAlignment = .Left
        drinkNotesLabel.hidden = true
        
        removeButton.hidden = !editMode
        removeButton.frame = CGRectMake(15, 25, 20, 20)
        removeButton.layer.cornerRadius = 0.5 * removeButton.bounds.size.width
        removeButton.setTitle("-", forState: .Normal)
        removeButton.backgroundColor = UIColor.redColor()
        removeButton.addTarget(self, action: "removeClicked", forControlEvents: .TouchUpInside)
        removeButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func removeClicked() {
        delegate?.removeDrinkIngredient(drinkIngredient!)
    }

    func sliderChanged() {
        drinkIngredient?.amount = (Int)(slider.value)
        ingredientAmountLabel.text = "\(drinkIngredient!.amount)ml"
    }
    
    func displayDrinkIngredient(drinkIngredient: DrinkIngredient) {
        self.drinkIngredient = drinkIngredient
        ingredientNamelabel.text = drinkIngredient.ingredient.type
        ingredientAmountLabel.text = "\(self.drinkIngredient!.amount)ml"
        removeButton.hidden = !editMode
        
        if(self.drinkIngredient?.ingredient.type == "Lime Juice" && !editMode){
            slider.hidden = true
            ingredientAmountLabel.hidden = true
            drinkNotesLabel.text = "Please pour \(self.drinkIngredient!.amount)ml Lime Juice yourself"
            drinkNotesLabel.hidden = false
        } else {
            slider.hidden = false
            ingredientAmountLabel.hidden = false
            drinkNotesLabel.text = ""
            drinkNotesLabel.hidden = true
        }
        
        if (drinkIngredient.ingredient.ingredientClass == .Alcoholic) {
            slider.setConfig(minimumValue: 0, maximumValue: 90, increment: 15)
        } else {
            slider.setConfig(minimumValue: 0, maximumValue: 180, increment: 30)
        }
        
        slider.setValue(drinkIngredient.amount.floatValue, animated: false)
    }
    
}
