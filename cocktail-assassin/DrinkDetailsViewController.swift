import UIKit
import iOSSharedViewTransition
import PromiseKit

class DrinkDetailsViewController: UIViewController, ASFSharedViewTransitionDataSource, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SelectIngredientDelegate, RemoveIngredientDelegate {
    let drinkImageView = UIImageView(frame: Constants.drinkFrames.expandedFrame)
    let backButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    let editButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    let saveButton = ActionButton(frame: CGRectMake(570, 650, 400, 60))
    let cancelButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    let deleteButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    let pourButton = ActionButton(frame: CGRectMake(570, 650, 400, 60))
    let resetIngredientButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    let ingredientsTableView = UITableView()
    let nameLabel = UILabel()
    let nameTextField = UITextField()

    var drink: Drink?
    var editMode = false
    var ingredientsPopoverController: UIPopoverController?

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(drink: Drink) {
        super.init(nibName: nil, bundle: nil)
        
        self.drink = drink

        pourButton.setTitle("Hit me!", forState: .Normal)

        drinkImageView.frame = Constants.drinkFrames.expandedFrame
        drinkImageView.contentMode = .ScaleAspectFit
        drinkImageView.image = UIImage(named: drink.imageName)
        view.addSubview(drinkImageView)
        
        editButton.frame = CGRectMake(900, 30, 100, 60)
        editButton.setTitle("Edit", forState: .Normal)
        editButton.setTitleColor(ThemeColor.primary, forState: UIControlState.Normal)
        editButton.setTitleColor(ThemeColor.highlighted, forState: .Highlighted)
        editButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(20))
        view.addSubview(editButton)

        saveButton.setTitle("Save", forState: .Normal)
        saveButton.hidden = true
        view.addSubview(saveButton)

        cancelButton.frame = CGRectMake(900, 30, 100, 60)
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(ThemeColor.primary, forState: UIControlState.Normal)
        cancelButton.setTitleColor(ThemeColor.highlighted, forState: .Highlighted)
        cancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(20))
        cancelButton.hidden = true
        view.addSubview(cancelButton)

        deleteButton.frame = CGRectMake(800, 30, 100, 60)
        deleteButton.setTitle("Delete", forState: .Normal)
        deleteButton.setTitleColor(ThemeColor.primary, forState: UIControlState.Normal)
        deleteButton.setTitleColor(ThemeColor.highlighted, forState: .Highlighted)
        deleteButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(20))
        deleteButton.hidden = true
        view.addSubview(deleteButton)
        
        backButton.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        backButton.setTitle("  Back", forState: .Normal)
        backButton.setTitleColor(ThemeColor.primary, forState: UIControlState.Normal)
        backButton.setTitleColor(ThemeColor.highlighted, forState: .Highlighted)
        backButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(20))
        backButton.frame = CGRectMake(30, 30, 100, 60)
        view.addSubview(backButton)
        
        ingredientsTableView.frame = CGRectMake(400, 180, 550, 410)
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.separatorStyle = .None
        ingredientsTableView.allowsSelection = true
        view.addSubview(ingredientsTableView)
        
        resetIngredientButton.setImage(UIImage(named: "reset.png"), forState: UIControlState.Normal)
        resetIngredientButton.setTitle("  Reset ingredients", forState: .Normal)
        resetIngredientButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(16))
        resetIngredientButton.frame = CGRectMake(620, 590, 300, 60)
        resetIngredientButton.backgroundColor = UIColor.clearColor()
        resetIngredientButton.setTitleColor(ThemeColor.primary, forState: .Normal)
        resetIngredientButton.setTitleColor(ThemeColor.highlighted, forState: .Highlighted)
        resetIngredientButton.titleLabel?.textAlignment = .Center
        view.addSubview(resetIngredientButton)
        
        nameLabel.frame = CGRectMake(500, 100, 500, 50)
        nameLabel.text = drink.name
        nameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        nameLabel.textAlignment = .Center
        view.addSubview(nameLabel)
        
        nameTextField.frame = CGRectMake(500, 100, 500, 50)
        nameTextField.text = drink.name
        nameTextField.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        nameTextField.textAlignment = .Center
        nameTextField.hidden = true
        nameTextField.borderStyle = UITextBorderStyle.Line
        nameTextField.delegate = self
        view.addSubview(nameTextField)

        let ingredients = Ingredient.allIngredients(drink.managedObjectContext!)
        let selectIngredientController = SelectIngredientViewController(ingredients: ingredients)
        selectIngredientController.delegate = self
        ingredientsPopoverController = UIPopoverController(contentViewController: selectIngredientController)

        resetIngredientButton.addTarget(self, action: "reset", forControlEvents: .TouchUpInside)
        backButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        editButton.addTarget(self, action: "edit", forControlEvents: .TouchUpInside)
        saveButton.addTarget(self, action: "save", forControlEvents: .TouchUpInside)
        cancelButton.addTarget(self, action: "cancel", forControlEvents: .TouchUpInside)
        deleteButton.addTarget(self, action: "delete", forControlEvents: .TouchUpInside)
        pourButton.addTarget(self, action: "pour", forControlEvents: .TouchUpInside)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editMode ? drink!.drinkIngredients.count+1 : drink!.drinkIngredients.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if( indexPath.row == drink?.drinkIngredients.count ) {
            return addIngredientCell(tableView, indexPath: indexPath)
        } else {
            return drinkIngredientCell(tableView, indexPath: indexPath)
        }
    }

    func addIngredientCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "ADD_INGREDIENT")
        cell.textLabel?.text = "Add Ingredient"
        cell.selectionStyle = .None
        return cell
    }

    func drinkIngredientCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? DrinkIngredientCell
        if(cell == nil) {
            cell = DrinkIngredientCell(style: .Default, reuseIdentifier: "CELL")
        }

        var drinkIngredient = drink?.drinkIngredients.allObjects[indexPath.row] as! DrinkIngredient

        cell!.editMode = self.editMode
        cell!.displayDrinkIngredient(drinkIngredient)
        cell!.delegate = self
        cell!.selectionStyle = .None

        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(pourButton)
    }
    
    func reset(){
        Drink.revert()
        ingredientsTableView.reloadData()
    }
    
    func dismiss(){
        Drink.revert()
        navigationController?.popViewControllerAnimated(true)
    }

    func edit() {
        editMode = true
        
        updateUserInterface()
    }

    func delete() {
        drink!.managedObjectContext?.deleteObject(drink!)
        Drink.save()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func save() {
        drink?.name = nameTextField.text
        
        editMode = false
        Drink.save()
        updateUserInterface()
    }

    func cancel() {
        if( !drink!.objectID.temporaryID ) {
            editMode = false
            
            Drink.revert()
            
            updateUserInterface()
        } else {
            dismiss()
        }
    }

    func updateUserInterface() {
        nameLabel.text = drink?.name
        nameLabel.hidden = editMode
        nameTextField.hidden = !editMode
        editButton.hidden = editMode
        cancelButton.hidden = !editMode
        saveButton.hidden = !editMode
        pourButton.hidden = editMode
        deleteButton.hidden = !editMode
        ingredientsTableView.reloadData()
    }
    
    func pour(){
        let ingredients = drink!.drinkIngredients.allObjects.map { $0 as! DrinkIngredient }
        let recipe = "/".join(ingredients.map {"\($0.ingredient.pumpNumber)-\($0.amount)"})
        pourButton.setState(.Loading)
        
        let promise = DrinkService.makeDrink(recipe: recipe)
        promise.then(body:{ (duration: Double) -> Void in
            Drink.revert()
            self.startPourAnimation(duration)
        })
        promise.catch(body: { (error: NSError) -> Void in
            self.pourButton.displayError(self.getErrorMessage(error.code));
        })

    }
    
    func getErrorMessage(code: Int) -> String {
        switch(code) {
            case 404:
                return "404 - Glass Not Found!"
            case 503:
                return "I'm Busy, Wait your turn!"
            default:
                return "Epic Fail!"
        }

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if editMode && indexPath.row == drink?.drinkIngredients.count {
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            let rect = CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, 70, 70)
            ingredientsPopoverController?.presentPopoverFromRect(
                rect, inView: cell, permittedArrowDirections: UIPopoverArrowDirection.Left, animated: true
            )
        }
    }

    func didSelectIngredient(ingredient: Ingredient) {
        ingredientsPopoverController?.dismissPopoverAnimated(true)
        if( drink!.hasIngredient(ingredient) ) {
            var alertView = UIAlertView(title: "Ingredient Already Added", message: "", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        } else {
            drink?.addIngredient(ingredient, amount: 30)
            updateUserInterface()
        }
    }

    func removeDrinkIngredient(ingredient: DrinkIngredient) {
        drink?.removeDrinkIngredient(ingredient)
        updateUserInterface()
    }

    func startPourAnimation(duration: Double) {
        var pouringVC = PouringViewController(drink: drink!, duration: duration)
        navigationController?.pushViewController(pouringVC, animated: true)
    }
    
    func sharedView() -> UIView! {
        return drinkImageView
    }

}