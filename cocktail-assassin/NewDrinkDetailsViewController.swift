import UIKit
import iOSSharedViewTransition
import PromiseKit

class NewDrinkDetailsViewController: UIViewController, ASFSharedViewTransitionDataSource, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SelectIngredientDelegate, RemoveIngredientDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate {
    
    @IBOutlet var drinkImageView: UIImageView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var pourButton: ActionButton!
    @IBOutlet var ingredientsTableView: UITableView!
    @IBOutlet var nameLabel: UILabel!
    
    var selectedIndexPath: NSIndexPath?
    var drink: Drink?
    var imageSize: CGSize!
    @IBOutlet var imageWidth: NSLayoutConstraint!
    @IBOutlet var imageHeight: NSLayoutConstraint!
    
    // Edit mode UI
    var editMode = false
    let nameTextField = UITextField()
    let imagePickerController = UIImagePickerController()
    let resetIngredientButton = UIButton(type: UIButtonType.Custom)
    var selectIngredientController: SelectIngredientViewController?
    let saveButton = ActionButton(frame: CGRectMake(570, 650, 400, 60))
    let cancelButton = UIButton(type: UIButtonType.Custom)
    let deleteButton = UIButton(type: UIButtonType.Custom)
    let selectImageButton = UIButton(type: UIButtonType.Custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad - Detail Drink Image: \(drinkImageView.frame)")
        
        imageWidth.constant = imageSize.width
        imageHeight.constant = imageSize.height
        
        imagePickerController.modalPresentationStyle = .FormSheet
        
        pourButton.setTitle("Hit me!", forState: .Normal)
        
        view.backgroundColor = UIColor.whiteColor()
        
        drinkImageView.contentMode = .ScaleAspectFit
        drinkImageView.image = drink?.image()
//        drinkImageView.backgroundColor = UIColor.blueColor()
        
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

        
        selectImageButton.setTitle("Select Image", forState: .Normal)
        selectImageButton.setTitleColor(ThemeColor.primary, forState: UIControlState.Normal)
        selectImageButton.setTitleColor(ThemeColor.highlighted, forState: .Highlighted)
        selectImageButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(20))
        selectImageButton.frame = CGRectMake(30, 670, 150, 60)
        selectImageButton.hidden = true
        view.addSubview(selectImageButton)
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = .SavedPhotosAlbum
        imagePickerController.allowsEditing = false
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.scrollEnabled = true
        ingredientsTableView.separatorStyle = .None
        ingredientsTableView.allowsSelection = true
        ingredientsTableView.alwaysBounceVertical = false
//        let inset = UIEdgeInsetsMake(30, 0, 30, 0)
//        ingredientsTableView.contentInset = inset
//        ingredientsTableView.scrollIndicatorInsets = inset
        
        // Todo: Subclass UITableView
//        let fadedTableView = UIView(frame: ingredientsTableView.frame);
//        fadedTableView.backgroundColor = UIColor.redColor()
//        fadedTableView.opaque = false
        
        
//        ingredientsTableView.opaque = false
//        let gradient = CAGradientLayer();
//        gradient.frame = ingredientsTableView.bounds;
//        gradient.colors = [
//            UIColor.clearColor().CGColor,
//            UIColor.whiteColor().CGColor,
//            UIColor.whiteColor().CGColor,
//            UIColor.clearColor().CGColor
//        ]
//        gradient.locations = [0, 0.1, 0.9, 1];
//        ingredientsTableView.layer.mask = gradient
        
        
//        fadedTableView.addSubview(ingredientsTableView)        
//        view.addSubview(fadedTableView)
        
        resetIngredientButton.setImage(UIImage(named: "reset.png"), forState: UIControlState.Normal)
        resetIngredientButton.setTitle("  Reset ingredients", forState: .Normal)
        resetIngredientButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(16))
        resetIngredientButton.frame = CGRectMake(620, 610, 300, 50)
        resetIngredientButton.backgroundColor = UIColor.clearColor()
        resetIngredientButton.setTitleColor(ThemeColor.primary, forState: .Normal)
        resetIngredientButton.setTitleColor(ThemeColor.highlighted, forState: .Highlighted)
        resetIngredientButton.titleLabel?.textAlignment = .Center
        view.addSubview(resetIngredientButton)
        
        nameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        nameLabel.textAlignment = .Center
        nameLabel.text = drink?.name
        
        nameTextField.frame = CGRectMake(480, 75, 480, 50)
        nameTextField.text = drink?.name
        nameTextField.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        nameTextField.textAlignment = .Center
        nameTextField.hidden = true
        nameTextField.borderStyle = UITextBorderStyle.Line
        nameTextField.clearsOnBeginEditing = true
        nameTextField.delegate = self
        view.addSubview(nameTextField)
        
        if let drink = drink {
            let ingredients = Ingredient.allIngredients(drink.managedObjectContext!)
            self.selectIngredientController = SelectIngredientViewController(ingredients: ingredients)
        }
        selectIngredientController?.delegate = self
        selectIngredientController?.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        
        resetIngredientButton.addTarget(self, action: "reset", forControlEvents: .TouchUpInside)
        backButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        editButton.addTarget(self, action: "edit", forControlEvents: .TouchUpInside)
        saveButton.addTarget(self, action: "save", forControlEvents: .TouchUpInside)
        cancelButton.addTarget(self, action: "cancel", forControlEvents: .TouchUpInside)
        deleteButton.addTarget(self, action: "delete", forControlEvents: .TouchUpInside)
        pourButton.addTarget(self, action: "pour", forControlEvents: .TouchUpInside)
        selectImageButton.addTarget(self, action: "selectImage", forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear - Detail Drink Image: \(drinkImageView.frame)")
        view.layoutSubviews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear - Detail Drink Image: \(drinkImageView.frame)")
    }
    
    func debugLayout() {
        editButton.backgroundColor = UIColor.blueColor()
        drinkImageView.backgroundColor = UIColor.blueColor()
        saveButton.backgroundColor = UIColor.blueColor()
        cancelButton.backgroundColor = UIColor.blueColor()
        deleteButton.backgroundColor = UIColor.blueColor()
        backButton.backgroundColor = UIColor.blueColor()
        selectImageButton.backgroundColor = UIColor.blueColor()
        ingredientsTableView.backgroundColor = UIColor.greenColor()
        resetIngredientButton.backgroundColor = UIColor.blueColor()        
        nameLabel.backgroundColor = UIColor.blueColor()
        nameTextField.backgroundColor = UIColor.blueColor()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imagePickerController.dismissViewControllerAnimated(true) { }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        drinkImageView.image = image
        drink?.saveImage(image)
        imagePickerController.dismissViewControllerAnimated(true) { }
    }
    
    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
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
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "ADD_INGREDIENT")
        cell.textLabel?.text = "Add Ingredient"
        cell.selectionStyle = .None
        return cell
    }

    func drinkIngredientCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IngredientCell") as? DrinkIngredientCell

        var sortedIngredients = (drink?.drinkIngredients.allObjects as! [DrinkIngredient]).sort { first, second in
            return first.ingredient.ingredientClass.rawValue <= second.ingredient.ingredientClass.rawValue &&
                first.ingredient.ingredientType != .LimeJuice
        }
        let drinkIngredient = sortedIngredients[indexPath.row] as DrinkIngredient

        cell!.editMode = self.editMode
        cell!.displayDrinkIngredient(drinkIngredient)
        cell!.delegate = self
        cell!.selectionStyle = .None

        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath == selectedIndexPath ? 85 : 38
    }
    
    func selectImage() {
        self.presentViewController(imagePickerController, animated: true) { }
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
        print("edit - Detail Drink Image: \(drinkImageView.frame)")
        editMode = true
        
        updateUserInterface()
    }

    func delete() {
        drink!.managedObjectContext?.deleteObject(drink!)
        Drink.save()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func validateDrink() -> String{
        var errorMessage = ""
        if((nameTextField.text) == ""){
            errorMessage = "Name for the drink?\n"
        }
        if(drink?.drinkIngredients.count == 0){
            errorMessage =  "\(errorMessage) You need at least one ingredient, silly. =P"
        }
        return errorMessage
    }

    func save() {
        let errorMessage = validateDrink()
        if errorMessage == "" {
            drink?.name = nameTextField.text!
        
            editMode = false
            Drink.save()
            updateUserInterface()
        }else{
            let alertController = UIAlertController(title: errorMessage, message: "", preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true) { }
        }
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
        selectImageButton.hidden = !editMode
        ingredientsTableView.reloadData()
    }
    
    func pour() {
        let ingredients = drink!.drinkIngredients.allObjects.filter { return $0.ingredient.pumpNumber != 10  } as! [DrinkIngredient]
        let ingredientComponents = ingredients.map {"\($0.ingredient.component!.id)-\($0.amount)"}
        let recipe = ingredientComponents.joinWithSeparator("/")
        pourButton.setState(.Loading)

        // TODO: get this to work!
        DrinkService.makeDrink(recipe: recipe).then() { duration -> Void in
            Drink.revert()
            self.startPourAnimation(duration)
        }.error() { error in
            print("What is ErrorType ?? \(error)")
//            self.getErrorMessage(error)
            self.pourButton.displayError("Error")
        }
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
        selectedIndexPath = selectedIndexPath == indexPath ? nil : indexPath
        if editMode && indexPath.row == drink?.drinkIngredients.count {
            self.presentViewController(self.selectIngredientController!, animated: true) { }
        }
        ingredientsTableView.beginUpdates()
        ingredientsTableView.endUpdates()
    }

    func didSelectIngredient(ingredient: Ingredient) {
        selectIngredientController?.dismissViewControllerAnimated(true) { }
        if( drink!.hasIngredient(ingredient) ) {
            let alertController = UIAlertController(title: "Ingredient Already Added", message: "", preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true) { }
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
        let pouringVC = PouringViewController(drink: drink!, duration: duration)
        navigationController?.pushViewController(pouringVC, animated: true)
    }
    
    func sharedView() -> UIView! {
        print("NewDrinkDetailsViewController.sharedView - Detail Drink Image: \(drinkImageView.frame)")
        
//        drinkImageView.frame = CGRect(origin: drinkImageView.frame.origin, size: imageSize)
        
        // Massive Hack! - Spent too long messing around with this stuff. This will do for now.
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            if drinkImageView.frame.origin.x < 10 {
                drinkImageView.frame = CGRect(origin: CGPoint(x: 76.0, y: 27.0), size: imageSize)
            }
        } else {
            if drinkImageView.frame.origin.x < 100 {
                drinkImageView.frame = CGRect(origin: CGPoint(x: 118.0, y: 67.0), size: imageSize)
            }
        }
        
        return drinkImageView
    }

}