import UIKit
import iOSSharedViewTransition
import PromiseKit

class DrinkDetailsViewController: UIViewController, ASFSharedViewTransitionDataSource, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SelectIngredientDelegate, RemoveIngredientDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate {

    var coreDataStack: CoreDataStack!
    var drink: Drink?
    var imageSize: CGSize!
    var imageFrame: CGRect!
    var selectedIndexPath: NSIndexPath?
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var drinkImageView: UIImageView!
    @IBOutlet var ingredientsTableView: UITableView!
    @IBOutlet var pourButton: ActionButton!
    
    @IBOutlet var imageWidth: NSLayoutConstraint!
    @IBOutlet var imageHeight: NSLayoutConstraint!
    
    // Edit mode UI
    var editMode = false
    let nameTextField = UITextField()
    let imagePickerController = UIImagePickerController()
    let resetIngredientButton = UIButton(type: UIButtonType.Custom)
    var selectIngredientController: SelectIngredientViewController?
    let saveButton = ActionButton(frame: CGRectZero)
    let cancelButton = UIButton(type: UIButtonType.Custom)
    let deleteButton = UIButton(type: UIButtonType.Custom)
    let selectImageButton = UIButton(type: UIButtonType.Custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageWidth.constant = imageSize.width
        imageHeight.constant = imageSize.height
        
        imagePickerController.modalPresentationStyle = .CurrentContext
        
        view.backgroundColor = UIColor.whiteColor()

        drinkImageView.image = drink?.image()
        drinkImageView.userInteractionEnabled = false
        
        editButton.imageView?.contentMode = .ScaleAspectFit
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.scrollEnabled = true
        ingredientsTableView.separatorStyle = .None
        ingredientsTableView.allowsSelection = true
        ingredientsTableView.alwaysBounceVertical = false
        
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
        
        // TODO: re-implement reset button
//        resetIngredientButton.setImage(UIImage(named: "reset.png"), forState: UIControlState.Normal)
//        resetIngredientButton.setTitle("  Reset ingredients", forState: .Normal)
//        resetIngredientButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(16))
//        resetIngredientButton.frame = CGRectMake(620, 610, 300, 50)
//        resetIngredientButton.backgroundColor = UIColor.clearColor()
//        resetIngredientButton.setTitleColor(ThemeColor.primary, forState: .Normal)
//        resetIngredientButton.setTitleColor(ThemeColor.highlighted, forState: .Highlighted)
//        resetIngredientButton.titleLabel?.textAlignment = .Center
//        resetIngredientButton.addTarget(self, action: "reset", forControlEvents: .TouchUpInside)
//        view.addSubview(resetIngredientButton)
        
        nameLabel.text = drink?.name
        
        backButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        editButton.addTarget(self, action: "edit", forControlEvents: .TouchUpInside)
        pourButton.addTarget(self, action: "pour", forControlEvents: .TouchUpInside)
        
        setupEditingUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let canEdit = AdminService.sharedInstance.isAdmin || drink!.editable
        editButton.hidden = !canEdit
    }
    
    func setupEditingUI() {
        cancelButton.setImage(UIImage(named: "cancel"), forState: .Normal)
        cancelButton.imageView?.contentMode = .ScaleAspectFit
        cancelButton.hidden = true
        cancelButton.addTarget(self, action: "cancel", forControlEvents: .TouchUpInside)
        headerView.addSubview(cancelButton)
        
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.hidden = true
        saveButton.addTarget(self, action: "save", forControlEvents: .TouchUpInside)
        view.addSubview(saveButton)

        nameTextField.frame = nameLabel.frame
        nameTextField.text = drink?.name
        nameTextField.textAlignment = .Center
        nameTextField.hidden = true
        nameTextField.borderStyle = UITextBorderStyle.Line
        nameTextField.delegate = self
        nameTextField.setBorder(1.0, color: UIColor.grayColor().CGColor, radius: 5)
        headerView.addSubview(nameTextField)
        
        selectImageButton.setImage(UIImage(named: "change_image"), forState: .Normal)
        selectImageButton.frame = CGRectMake(20, view.frame.size.height-52, 32, 32)
        selectImageButton.hidden = true
        selectImageButton.addTarget(self, action: "selectImage", forControlEvents: .TouchUpInside)
        view.addSubview(selectImageButton)

        // TODO: re-implement the delete button
//        deleteButton.hidden = true
//        deleteButton.addTarget(self, action: "delete", forControlEvents: .TouchUpInside)        
//        view.addSubview(deleteButton)
        
        if let drink = drink {
            self.selectIngredientController = SelectIngredientForDrinkViewController(drink: drink, coreDataStack: coreDataStack)
        }
        selectIngredientController?.delegate = self
        selectIngredientController?.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = .SavedPhotosAlbum
        imagePickerController.allowsEditing = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if editMode {
            edit()
            if nameTextField.text == "" {
                nameTextField.becomeFirstResponder()
            }            
        }
    }
    
    func drinkIngredientForIndexPath(indexPath: NSIndexPath) -> DrinkIngredient? {
        let ingredients = drink?.drinkIngredients.allObjects as! [DrinkIngredient]
        var sortedIngredients = ingredients.sort { first, second in
            return first.ingredient.ingredientClass.rawValue <= second.ingredient.ingredientClass.rawValue &&
                first.ingredient.ingredientType != .LimeJuice
        }
        if sortedIngredients.count > indexPath.row {
            return sortedIngredients[indexPath.row] as DrinkIngredient
        }
        return nil
    }
    
    @IBAction func pour() {
        let ingredients = drink!.drinkIngredients.allObjects as! [DrinkIngredient]
        let missingIngredients = ingredients.filter { $0.ingredient.component == nil }
        if missingIngredients.count > 0 {
            let missingIngredient = missingIngredients[0]
            self.pourButton.displayError("\(missingIngredient.ingredient.ingredientType.rawValue) Missing")
            return
        }
        
        if drink!.total() > 260 {
            self.pourButton.displayError("Overflow!")
            return
        }
        
        let ingredientComponents = ingredients.map {"\($0.ingredient.component!.id)-\($0.amount)"}
        let recipe = ingredientComponents.joinWithSeparator("/")
        pourButton.setState(.Loading)
        
        // TODO: get this to work!
        DrinkService.makeDrink(recipe: recipe).then() { duration -> Void in
            self.coreDataStack.revert()
            self.startPourAnimation(duration)
            }.error() { error in
                print("What is ErrorType ?? \(error)")
                //            self.getErrorMessage(error)
                self.pourButton.displayError("Error")
        }
    }
    
    @IBAction func edit() {
        nameTextField.text = drink!.name
        nameTextField.frame = nameLabel.frame
        nameTextField.font = nameLabel.font
        cancelButton.frame = editButton.frame
        saveButton.frame = pourButton.frame
        editMode = true
        selectedIndexPath = nil
        ingredientsTableView.reloadData()
        
        updateUserInterface()
    }
    
    @IBAction func cancel() {
        if( !drink!.objectID.temporaryID ) {
            editMode = false
            nameTextField.resignFirstResponder()
            selectedIndexPath = nil
            coreDataStack.revert()
            ingredientsTableView.reloadData()
            updateUserInterface()
        } else {
            dismiss()
        }
    }
    
    @IBAction func save() {
        let errorMessage = validateDrink()
        if errorMessage == "" {
            drink?.name = nameTextField.text!
            editMode = false
            selectedIndexPath = nil
            coreDataStack.save()
            updateUserInterface()
        } else {
            let alertController = UIAlertController(title: errorMessage, message: "", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func delete() {
        drink!.managedObjectContext?.deleteObject(drink!)
        coreDataStack.save()
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func selectImage() {
        if editMode {
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func reset() {
        coreDataStack.revert()
        ingredientsTableView.reloadData()
    }
    
    func dismiss() {
        coreDataStack.revert()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func validateDrink() -> String {
        var errorMessage = ""
        if((nameTextField.text) == ""){
            errorMessage = "Name for the drink?\n"
        }
        if(drink?.drinkIngredients.count == 0){
            errorMessage =  "\(errorMessage) You need at least one ingredient, silly. 😋"
        }
        return errorMessage
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
        drinkImageView.userInteractionEnabled = editMode
        ingredientsTableView.reloadData()
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
    
    func isSelected(indexPath: NSIndexPath) -> Bool {
        return selectedIndexPath == indexPath
    }

    func isCompact() -> Bool {
        return UIDevice.currentDevice().userInterfaceIdiom == .Phone
    }
    
    func didSelectIngredient(ingredient: Ingredient?) {
        guard let ingredient = ingredient else {
            return
        }
        selectIngredientController?.dismissViewControllerAnimated(true, completion: nil)
        if( drink!.hasIngredient(ingredient) ) {
            let alertController = UIAlertController(title: "Ingredient Already Added", message: "", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            drink?.addIngredient(ingredient, amount: 30)
            updateUserInterface()
        }
    }
    
    func didCancel() {
        selectIngredientController?.dismissViewControllerAnimated(true) { }
    }

    func removeDrinkIngredient(ingredient: DrinkIngredient) {
        drink?.removeDrinkIngredient(ingredient)
        updateUserInterface()
    }

    func amountChanged(ingredient: DrinkIngredient) {
        ingredientsTableView.reloadData()
    }
    
    func startPourAnimation(duration: Double) {
        let pouringVC = PouringViewController(drink: drink!, duration: duration, imageSize: imageSize)
        navigationController?.pushViewController(pouringVC, animated: true)
    }
    
    func sharedView() -> UIView! {
        // Massive Hack! - Spent too long messing around with this stuff.
        drinkImageView.frame = CGRect(
            origin: CGPoint(x: 50, y: view.frame.size.height - imageSize.height - 20),
            size: imageSize
        )
        
        return drinkImageView
    }
    
    // MARK: UITableView Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editMode ? drink!.drinkIngredients.count+1 : drink!.drinkIngredients.count+1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = tableView.frame.size.height / 6
        if isCompact() && isSelected(indexPath) {
            return height * 1.75
        } else {
            return height
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if( indexPath.row == drink?.drinkIngredients.count ) {
            if editMode {
                return tableView.dequeueReusableCellWithIdentifier("AddIngredient")!
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("TotalCell") as! DrinkTotalCell
                cell.update(drink!)
                return cell
            }
        } else {
            return drinkIngredientCell(tableView, indexPath: indexPath)
        }
    }
    
    func drinkIngredientCell(tableView: UITableView, indexPath: NSIndexPath) -> DrinkIngredientCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IngredientCell") as? DrinkIngredientCell
        let drinkIngredient = drinkIngredientForIndexPath(indexPath)!
        
        cell!.editMode = self.editMode
        cell!.editing =  self.editMode
        cell!.displayDrinkIngredient(drinkIngredient)
        cell!.delegate = self
        let hidden = isCompact() && !isSelected(indexPath)
        cell!.slider?.alpha = hidden ? 0.0 : 1.0
        cell!.selectionStyle = .None
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if editMode && indexPath.row == drink?.drinkIngredients.count {
            let navController = UINavigationController(rootViewController: self.selectIngredientController!)
            self.presentViewController(navController, animated: true) { }
        } else if isCompact() {
            ingredientsTableView.beginUpdates()
            
            if let selectedIndexPath = selectedIndexPath {
                if let cell = tableView.cellForRowAtIndexPath(selectedIndexPath) as? DrinkIngredientCell {
                    UIView.animateWithDuration(0.3) {
                        cell.slider?.alpha = 0.0
                    }
                }
            }
            
            if selectedIndexPath != indexPath {
                selectedIndexPath = indexPath
                if let cell = tableView.cellForRowAtIndexPath(indexPath) as? DrinkIngredientCell {
                    UIView.animateWithDuration(
                        0.3,
                        animations: {
                            cell.slider?.alpha = 1.0
                        }
                    )
                }
                var rect = tableView.rectForRowAtIndexPath(indexPath)
                rect = rect.transform(0, y: 0, width: 0, height: rect.size.height * 0.75)
                tableView.scrollRectToVisible(rect, animated: true)
            } else {
                selectedIndexPath = nil
            }
            ingredientsTableView.endUpdates()
        }
    }
    
    // MARK: UITextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        drink!.name = text.stringByReplacingCharactersInRange(range, withString:string)
        return true
    }
    
    // MARK: ImagePicker Delegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imagePickerController.dismissViewControllerAnimated(true) { }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        drinkImageView.image = image
        drink?.saveImage(image)
        imagePickerController.dismissViewControllerAnimated(true) { }
    }

}