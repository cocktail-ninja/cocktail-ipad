import UIKit
import iOSSharedViewTransition
import PromiseKit

class DrinkDetailsViewController: UIViewController {

    var coreDataStack: CoreDataStack!
    var drink: Drink?
    var imageSize: CGSize!
    var imageFrame: CGRect!
    var selectedIndexPath: IndexPath?
    
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
    let resetIngredientButton = UIButton(type: UIButtonType.custom)
    var selectIngredientController: SelectIngredientViewController?
    let saveButton = ActionButton(frame: CGRect.zero)
    let cancelButton = UIButton(type: UIButtonType.custom)
    let deleteButton = UIButton(type: UIButtonType.custom)
    let selectImageButton = UIButton(type: UIButtonType.custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageWidth.constant = imageSize.width
        imageHeight.constant = imageSize.height
        
        imagePickerController.modalPresentationStyle = .currentContext
        
        view.backgroundColor = UIColor.white

        drinkImageView.image = drink?.image()
        drinkImageView.isUserInteractionEnabled = false
        
        editButton.imageView?.contentMode = .scaleAspectFit
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.isScrollEnabled = true
        ingredientsTableView.separatorStyle = .none
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
        
        backButton.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(DrinkDetailsViewController.edit), for: .touchUpInside)
        pourButton.addTarget(self, action: #selector(DrinkDetailsViewController.pour), for: .touchUpInside)
        
        setupEditingUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let canEdit = AdminService.sharedInstance.isAdmin || drink!.editable
        editButton.isHidden = !canEdit
    }
    
    func setupEditingUI() {
        cancelButton.setImage(UIImage(named: "cancel"), for: UIControlState())
        cancelButton.imageView?.contentMode = .scaleAspectFit
        cancelButton.isHidden = true
        cancelButton.addTarget(self, action: #selector(DrinkDetailsViewController.cancel), for: .touchUpInside)
        headerView.addSubview(cancelButton)
        
        saveButton.setTitle("Save", for: UIControlState())
        saveButton.isHidden = true
        saveButton.addTarget(self, action: #selector(DrinkDetailsViewController.save), for: .touchUpInside)
        view.addSubview(saveButton)

        nameTextField.frame = nameLabel.frame
        nameTextField.text = drink?.name
        nameTextField.textAlignment = .center
        nameTextField.isHidden = true
        nameTextField.borderStyle = UITextBorderStyle.line
        nameTextField.delegate = self
        nameTextField.setBorder(1.0, color: UIColor.gray.cgColor, radius: 5)
        headerView.addSubview(nameTextField)
        
        selectImageButton.setImage(UIImage(named: "change_image"), for: UIControlState())
        selectImageButton.frame = CGRect(x: 20, y: view.frame.size.height-52, width: 32, height: 32)
        selectImageButton.isHidden = true
        selectImageButton.addTarget(self, action: #selector(DrinkDetailsViewController.selectImage), for: .touchUpInside)
        view.addSubview(selectImageButton)

        // TODO: re-implement the delete button
//        deleteButton.hidden = true
//        deleteButton.addTarget(self, action: "delete", forControlEvents: .TouchUpInside)        
//        view.addSubview(deleteButton)
        
        if let drink = drink {
            self.selectIngredientController = SelectIngredientForDrinkViewController(drink: drink, coreDataStack: coreDataStack)
        }
        selectIngredientController?.delegate = self
        selectIngredientController?.modalPresentationStyle = UIModalPresentationStyle.formSheet
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.allowsEditing = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if editMode {
            edit()
            if nameTextField.text == "" {
                nameTextField.becomeFirstResponder()
            }            
        }
    }
    
    func drinkIngredientForIndexPath(_ indexPath: IndexPath) -> DrinkIngredient? {
        let ingredients = Array(drink!.drinkIngredients)
        var sortedIngredients = ingredients.sorted { first, second in
            return first.ingredient.ingredientClass.rawValue <= second.ingredient.ingredientClass.rawValue &&
                first.ingredient.ingredientType != .limeJuice
        }
        if sortedIngredients.count > indexPath.row {
            return sortedIngredients[indexPath.row] as DrinkIngredient
        }
        return nil
    }
    
    @IBAction func pour() {
        let ingredients = Array(drink!.drinkIngredients)
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
        let recipe = ingredientComponents.joined(separator: "/")
        pourButton.setState(.loading)
        
        firstly {
            DrinkService.makeDrink(recipe: recipe)
        }.then { duration -> Void in
            self.coreDataStack.revert()
            self.startPourAnimation(duration)
        }.catch { error in
            print("What is ErrorType ?? \(error)")
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
        if !drink!.objectID.isTemporaryID {
            editMode = false
            nameTextField.resignFirstResponder()
            selectedIndexPath = nil
            coreDataStack.revert()
            ingredientsTableView.reloadData()
            updateUserInterface()
        } else {
            dismissView()
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
            let alertController = UIAlertController(title: errorMessage, message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func delete() {
        drink!.managedObjectContext?.delete(drink!)
        coreDataStack.save()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func selectImage() {
        if editMode {
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func reset() {
        coreDataStack.revert()
        ingredientsTableView.reloadData()
    }
    
    func dismissView() {
        coreDataStack.revert()
        navigationController?.popViewController(animated: true)
    }
    
    func validateDrink() -> String {
        var errorMessage = ""
        if nameTextField.text == "" {
            errorMessage = "Name for the drink?\n"
        }
        if drink?.drinkIngredients.count == 0 {
            errorMessage =  "\(errorMessage) You need at least one ingredient, silly. 😋"
        }
        return errorMessage
    }

    func updateUserInterface() {
        nameLabel.text = drink?.name
        nameLabel.isHidden = editMode
        nameTextField.isHidden = !editMode
        editButton.isHidden = editMode
        cancelButton.isHidden = !editMode
        saveButton.isHidden = !editMode
        pourButton.isHidden = editMode
        deleteButton.isHidden = !editMode
        selectImageButton.isHidden = !editMode
        drinkImageView.isUserInteractionEnabled = editMode
        ingredientsTableView.reloadData()
    }
    
    func getErrorMessage(_ code: Int) -> String {
        switch code {
            case 404:
                return "404 - Glass Not Found!"
            case 503:
                return "I'm Busy, Wait your turn!"
            default:
                return "Epic Fail!"
        }

    }
    
    func isSelected(_ indexPath: IndexPath) -> Bool {
        return selectedIndexPath == indexPath
    }

    func isCompact() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    func startPourAnimation(_ duration: Double) {
        let pouringVC = PouringViewController(drink: drink!, duration: duration, imageSize: imageSize)
        navigationController?.pushViewController(pouringVC, animated: true)
    }

}

extension DrinkDetailsViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if editMode && indexPath.row == drink?.drinkIngredients.count {
            let navController = UINavigationController(rootViewController: self.selectIngredientController!)
            self.present(navController, animated: true) { }
        } else if isCompact() {
            ingredientsTableView.beginUpdates()
            
            if let selectedIndexPath = selectedIndexPath {
                if let cell = tableView.cellForRow(at: selectedIndexPath) as? DrinkIngredientCell {
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.slider?.alpha = 0.0
                    })
                }
            }
            
            if selectedIndexPath != indexPath {
                selectedIndexPath = indexPath
                if let cell = tableView.cellForRow(at: indexPath) as? DrinkIngredientCell {
                    UIView.animate(
                        withDuration: 0.3,
                        animations: {
                            cell.slider?.alpha = 1.0
                    }
                    )
                }
                var rect = tableView.rectForRow(at: indexPath)
                rect = rect.transform(x: 0, y: 0, width: 0, height: rect.size.height * 0.75)
                tableView.scrollRectToVisible(rect, animated: true)
            } else {
                selectedIndexPath = nil
            }
            ingredientsTableView.endUpdates()
        }
    }
}

extension DrinkDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editMode ? drink!.drinkIngredients.count+1 : drink!.drinkIngredients.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.frame.size.height / 6
        if isCompact() && isSelected(indexPath) {
            return height * 1.75
        } else {
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == drink?.drinkIngredients.count {
            if editMode {
                return tableView.dequeueReusableCell(withIdentifier: "AddIngredient")!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCell") as! DrinkTotalCell
                cell.update(drink!)
                return cell
            }
        } else {
            return drinkIngredientCell(tableView, indexPath: indexPath)
        }
    }
    
    func drinkIngredientCell(_ tableView: UITableView, indexPath: IndexPath) -> DrinkIngredientCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell") as? DrinkIngredientCell
        let drinkIngredient = drinkIngredientForIndexPath(indexPath)!
        
        cell!.editMode = self.editMode
        cell!.isEditing =  self.editMode
        cell!.displayDrinkIngredient(drinkIngredient)
        cell!.delegate = self
        let hidden = isCompact() && !isSelected(indexPath)
        cell!.slider?.alpha = hidden ? 0.0 : 1.0
        cell!.selectionStyle = .none
        
        return cell!
    }
}

extension DrinkDetailsViewController: UITextFieldDelegate {
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        drink!.name = text.replacingCharacters(in: range, with:string)
        return true
    }
}

extension DrinkDetailsViewController: SelectIngredientDelegate {
    
    func didSelectIngredient(_ ingredient: Ingredient?) {
        guard let ingredient = ingredient else {
            return
        }
        selectIngredientController?.dismiss(animated: true, completion: nil)
        if drink!.hasIngredient(ingredient) {
            let alertController = UIAlertController(title: "Ingredient Already Added", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            drink?.addIngredient(ingredient, amount: 30)
            updateUserInterface()
        }
    }
    
    func didCancel() {
        selectIngredientController?.dismiss(animated: true) { }
    }
}

extension DrinkDetailsViewController: ASFSharedViewTransitionDataSource {
    
    func sharedView() -> UIView! {
        // Massive Hack! - Spent too long messing around with this stuff.
        drinkImageView.frame = CGRect(
            origin: CGPoint(x: 50, y: view.frame.size.height - imageSize.height - 20),
            size: imageSize
        )
        
        return drinkImageView
    }
}

extension DrinkDetailsViewController: RemoveIngredientDelegate {
    
    func removeDrinkIngredient(_ ingredient: DrinkIngredient) {
        drink?.removeDrinkIngredient(ingredient)
        updateUserInterface()
    }
    
    func amountChanged(_ ingredient: DrinkIngredient) {
        ingredientsTableView.reloadData()
    }
}

extension DrinkDetailsViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true) { }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            drinkImageView.image = image
            drink?.saveImage(image)
        }
        imagePickerController.dismiss(animated: true) { }
    }
}

extension DrinkDetailsViewController: UINavigationControllerDelegate {
    
}

extension DrinkDetailsViewController: UIPopoverControllerDelegate {
    
}
